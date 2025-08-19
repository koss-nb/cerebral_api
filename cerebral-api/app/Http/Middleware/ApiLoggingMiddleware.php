<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Symfony\Component\HttpFoundation\Response;

class ApiLoggingMiddleware
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next): Response
    {
        $startTime = microtime(true);
        
        // Log de la requête entrante
        Log::channel('api')->info('API Request', [
            'method' => $request->method(),
            'url' => $request->fullUrl(),
            'ip' => $request->ip(),
            'user_agent' => $request->userAgent(),
            'user_id' => $request->user()?->id ?? 'guest',
            'timestamp' => now()->toISOString(),
            'headers' => $request->headers->all(),
            'body' => $this->sanitizeRequestBody($request->all())
        ]);

        $response = $next($request);

        $endTime = microtime(true);
        $duration = round(($endTime - $startTime) * 1000, 2); // en millisecondes

        // Log de la réponse
        Log::channel('api')->info('API Response', [
            'method' => $request->method(),
            'url' => $request->fullUrl(),
            'status_code' => $response->getStatusCode(),
            'duration_ms' => $duration,
            'user_id' => $request->user()?->id ?? 'guest',
            'timestamp' => now()->toISOString(),
            'response_size' => strlen($response->getContent())
        ]);

        // Ajouter le temps de réponse dans les headers
        $response->headers->set('X-Response-Time', $duration . 'ms');
        $response->headers->set('X-Request-ID', uniqid('req_', true));

        return $response;
    }

    /**
     * Sanitize request body to remove sensitive data
     */
    private function sanitizeRequestBody(array $data): array
    {
        $sensitiveFields = ['password', 'password_confirmation', 'token', 'api_key'];
        
        foreach ($sensitiveFields as $field) {
            if (isset($data[$field])) {
                $data[$field] = '***HIDDEN***';
            }
        }
        
        return $data;
    }
}
