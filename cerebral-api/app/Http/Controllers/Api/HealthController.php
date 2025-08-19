<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Storage;

/**
 * @OA\Get(
 *     path="/health",
 *     summary="Vérifier la santé de l'API",
 *     tags={"Monitoring"},
 *     @OA\Response(
 *         response=200,
 *         description="API en bonne santé",
 *         @OA\JsonContent(
 *             @OA\Property(property="status", type="string", example="healthy"),
 *             @OA\Property(property="timestamp", type="string", format="date-time"),
 *             @OA\Property(property="version", type="string", example="1.0.0"),
 *             @OA\Property(property="database", type="object"),
 *             @OA\Property(property="cache", type="object"),
 *             @OA\Property(property="storage", type="object")
 *         )
 *     ),
 *     @OA\Response(
 *         response=503,
 *         description="API en mauvaise santé",
 *         @OA\JsonContent(
 *             @OA\Property(property="status", type="string", example="unhealthy"),
 *             @OA\Property(property="errors", type="array", @OA\Items(type="string"))
 *         )
 *     )
 * )
 */
class HealthController extends Controller
{
    public function check()
    {
        $health = [
            'status' => 'healthy',
            'timestamp' => now()->toISOString(),
            'version' => '1.0.0',
            'database' => $this->checkDatabase(),
            'cache' => $this->checkCache(),
            'storage' => $this->checkStorage(),
        ];

        $hasErrors = collect($health)
            ->except(['status', 'timestamp', 'version'])
            ->contains('status', 'error');

        if ($hasErrors) {
            $health['status'] = 'unhealthy';
            return response()->json($health, 503);
        }

        return response()->json($health);
    }

    private function checkDatabase()
    {
        try {
            DB::connection()->getPdo();
            $queryTime = $this->measureQueryTime();
            
            return [
                'status' => 'healthy',
                'connection' => 'connected',
                'query_time_ms' => $queryTime
            ];
        } catch (\Exception $e) {
            return [
                'status' => 'error',
                'connection' => 'disconnected',
                'error' => $e->getMessage()
            ];
        }
    }

    private function checkCache()
    {
        try {
            $testKey = 'health_check_' . uniqid();
            Cache::put($testKey, 'test', 1);
            $value = Cache::get($testKey);
            Cache::forget($testKey);

            return [
                'status' => 'healthy',
                'driver' => config('cache.default'),
                'test' => $value === 'test' ? 'passed' : 'failed'
            ];
        } catch (\Exception $e) {
            return [
                'status' => 'error',
                'driver' => config('cache.default'),
                'error' => $e->getMessage()
            ];
        }
    }

    private function checkStorage()
    {
        try {
            $testFile = 'health_check_' . uniqid() . '.txt';
            Storage::put($testFile, 'test');
            $exists = Storage::exists($testFile);
            Storage::delete($testFile);

            return [
                'status' => 'healthy',
                'driver' => config('filesystems.default'),
                'writable' => $exists ? 'yes' : 'no'
            ];
        } catch (\Exception $e) {
            return [
                'status' => 'error',
                'driver' => config('filesystems.default'),
                'error' => $e->getMessage()
            ];
        }
    }

    private function measureQueryTime()
    {
        $start = microtime(true);
        DB::select('SELECT 1');
        return round((microtime(true) - $start) * 1000, 2);
    }
}
