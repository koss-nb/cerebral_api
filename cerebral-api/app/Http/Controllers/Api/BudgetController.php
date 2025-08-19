<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\BudgetRequest;
use App\Http\Resources\BudgetResource;
use App\Models\Budget;
use App\Models\Project;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class BudgetController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Budget::with(['project', 'approvedBy', 'creator']);

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('type')) {
            $query->where('type', $request->type);
        }

        if ($request->has('category')) {
            $query->where('category', $request->category);
        }

        if ($request->has('fiscal_year')) {
            $query->where('fiscal_year', $request->fiscal_year);
        }

        if ($request->has('project_id')) {
            $query->where('project_id', $request->project_id);
        }

        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('description', 'like', "%{$search}%")
                    ->orWhere('category', 'like', "%{$search}%");
            });
        }

        $sortBy = $request->get('sort_by', 'created_at');
        $sortOrder = $request->get('sort_order', 'desc');
        $query->orderBy($sortBy, $sortOrder);

        $budgets = $query->paginate($request->get('per_page', 15));

        return response()->json([
            'success' => true,
            'data' => BudgetResource::collection($budgets),
            'meta' => [
                'current_page' => $budgets->currentPage(),
                'last_page' => $budgets->lastPage(),
                'per_page' => $budgets->perPage(),
                'total' => $budgets->total(),
            ],
        ]);
    }

    public function store(BudgetRequest $request): JsonResponse
    {
        try {
            DB::beginTransaction();
            $budget = Budget::create($request->validated());
            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Budget créé avec succès',
                'data' => new BudgetResource($budget->load(['project', 'approvedBy', 'creator'])),
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Erreur lors de la création du budget',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function show(Budget $budget): JsonResponse
    {
        $budget->load(['project', 'approvedBy', 'creator']);

        return response()->json([
            'success' => true,
            'data' => new BudgetResource($budget),
        ]);
    }

    public function update(BudgetRequest $request, Budget $budget): JsonResponse
    {
        try {
            DB::beginTransaction();
            $budget->update($request->validated());
            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Budget mis à jour avec succès',
                'data' => new BudgetResource($budget->load(['project', 'approvedBy', 'creator'])),
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Erreur lors de la mise à jour du budget',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function destroy(Budget $budget): JsonResponse
    {
        try {
            DB::beginTransaction();

            if ($budget->is_approved || $budget->is_executed) {
                return response()->json([
                    'success' => false,
                    'message' => 'Impossible de supprimer un budget approuvé ou exécuté',
                ], 422);
            }

            $budget->delete();
            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Budget supprimé avec succès',
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Erreur lors de la suppression du budget',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function approve(Request $request, Budget $budget): JsonResponse
    {
        if ($budget->is_approved) {
            return response()->json([
                'success' => false,
                'message' => 'Ce budget est déjà approuvé',
            ], 422);
        }

        $budget->update([
            'is_approved' => true,
            'approved_by' => auth()->id(),
            'approved_at' => now(),
            'status' => 'approved',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Budget approuvé avec succès',
            'data' => new BudgetResource($budget->load(['project', 'approvedBy', 'creator'])),
        ]);
    }

    public function stats(): JsonResponse
    {
        $stats = [
            'total' => Budget::count(),
            'total_amount' => Budget::sum('amount'),
            'approved' => Budget::where('is_approved', true)->count(),
            'executed' => Budget::where('is_executed', true)->count(),
            'pending' => Budget::where('status', 'pending')->count(),
            'by_type' => Budget::select('type', DB::raw('count(*) as count'), DB::raw('sum(amount) as total_amount'))
                ->groupBy('type')
                ->get(),
            'by_category' => Budget::select('category', DB::raw('count(*) as count'), DB::raw('sum(amount) as total_amount'))
                ->groupBy('category')
                ->get(),
        ];

        return response()->json([
            'success' => true,
            'data' => $stats,
        ]);
    }

    public function categories(): JsonResponse
    {
        $categories = Budget::select('category')
            ->distinct()
            ->pluck('category')
            ->sort()
            ->values();

        return response()->json([
            'success' => true,
            'data' => $categories,
        ]);
    }

    public function byProject(int $projectId): JsonResponse
    {
        $project = Project::findOrFail($projectId);

        $budgets = Budget::with(['approvedBy', 'creator'])
            ->where('project_id', $projectId)
            ->orderBy('created_at', 'desc')
            ->get();

        $stats = [
            'total_budgets' => $budgets->count(),
            'total_amount' => $budgets->sum('amount'),
            'approved_amount' => $budgets->where('is_approved', true)->sum('amount'),
            'executed_amount' => $budgets->where('is_executed', true)->sum('amount'),
        ];

        return response()->json([
            'success' => true,
            'data' => [
                'project' => [
                    'id' => $project->id,
                    'name' => $project->name,
                ],
                'budgets' => BudgetResource::collection($budgets),
                'stats' => $stats,
            ],
        ]);
    }

    public function export(Request $request): JsonResponse
    {
        $request->validate([
            'format' => 'required|in:csv,json,xml',
        ]);

        $budgets = Budget::with(['project', 'approvedBy'])->get();

        return response()->json([
            'success' => true,
            'message' => 'Export généré avec succès',
            'data' => [
                'format' => $request->format,
                'count' => $budgets->count(),
                'total_amount' => $budgets->sum('amount'),
                'budgets' => BudgetResource::collection($budgets),
            ],
        ]);
    }
}
