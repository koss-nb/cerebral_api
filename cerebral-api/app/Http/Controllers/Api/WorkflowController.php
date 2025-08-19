<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Workflow;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class WorkflowController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request): JsonResponse
    {
        $query = Workflow::with(['creator']);

        // Filtres
        if ($request->has('type')) {
            $query->where('type', $request->type);
        }

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('is_active')) {
            $query->where('is_active', $request->boolean('is_active'));
        }

        // Recherche
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('description', 'like', "%{$search}%");
            });
        }

        $workflows = $query->paginate($request->get('per_page', 15));

        return response()->json([
            'success' => true,
            'data' => $workflows->items(),
            'pagination' => [
                'current_page' => $workflows->currentPage(),
                'last_page' => $workflows->lastPage(),
                'per_page' => $workflows->perPage(),
                'total' => $workflows->total(),
            ],
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'type' => 'required|string|in:approval,review,validation',
            'status' => 'required|string|in:active,inactive,draft',
            'steps' => 'required|array',
            'conditions' => 'nullable|array',
            'created_by' => 'required|exists:users,id',
            'is_active' => 'boolean',
        ]);

        $workflow = Workflow::create($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Workflow created successfully',
            'data' => $workflow->load('creator'),
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Workflow $workflow): JsonResponse
    {
        $workflow->load(['creator']);

        return response()->json([
            'success' => true,
            'data' => $workflow,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Workflow $workflow): JsonResponse
    {
        $request->validate([
            'name' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'type' => 'sometimes|string|in:approval,review,validation',
            'status' => 'sometimes|string|in:active,inactive,draft',
            'steps' => 'sometimes|array',
            'conditions' => 'nullable|array',
            'is_active' => 'boolean',
        ]);

        $workflow->update($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Workflow updated successfully',
            'data' => $workflow->load('creator'),
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Workflow $workflow): JsonResponse
    {
        $workflow->delete();

        return response()->json([
            'success' => true,
            'message' => 'Workflow deleted successfully',
        ]);
    }

    /**
     * Activate workflow.
     */
    public function activate(Workflow $workflow): JsonResponse
    {
        $workflow->update([
            'status' => 'active',
            'is_active' => true,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Workflow activated successfully',
            'data' => [
                'id' => $workflow->getAttribute('id'),
                'name' => $workflow->getAttribute('name'),
                'status' => 'active',
                'is_active' => true,
            ],
        ]);
    }

    /**
     * Deactivate workflow.
     */
    public function deactivate(Workflow $workflow): JsonResponse
    {
        $workflow->update([
            'status' => 'inactive',
            'is_active' => false,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Workflow deactivated successfully',
            'data' => [
                'id' => $workflow->getAttribute('id'),
                'name' => $workflow->getAttribute('name'),
                'status' => 'inactive',
                'is_active' => false,
            ],
        ]);
    }

    /**
     * Get workflow steps.
     */
    public function steps(Workflow $workflow): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => [
                'workflow_id' => $workflow->id,
                'workflow_name' => $workflow->name,
                'steps' => $workflow->steps ?? [],
            ],
        ]);
    }

    /**
     * Update workflow steps.
     */
    public function updateSteps(Request $request, Workflow $workflow): JsonResponse
    {
        $request->validate([
            'steps' => 'required|array',
        ]);

        $workflow->update(['steps' => $request->steps]);

        return response()->json([
            'success' => true,
            'message' => 'Workflow steps updated successfully',
            'data' => $workflow->steps,
        ]);
    }

    /**
     * Get workflow types.
     */
    public function types(): JsonResponse
    {
        $types = [
            'approval' => 'Workflow d\'approbation',
            'review' => 'Workflow de révision',
            'validation' => 'Workflow de validation',
        ];

        return response()->json([
            'success' => true,
            'data' => $types,
        ]);
    }

    /**
     * Get workflow statistics.
     */
    public function stats(): JsonResponse
    {
        $stats = [
            'total_workflows' => Workflow::count(),
            'active_workflows' => Workflow::where('status', 'active')->count(),
            'draft_workflows' => Workflow::where('status', 'draft')->count(),
            'inactive_workflows' => Workflow::where('status', 'inactive')->count(),
            'by_type' => [
                'approval' => Workflow::where('type', 'approval')->count(),
                'review' => Workflow::where('type', 'review')->count(),
                'validation' => Workflow::where('type', 'validation')->count(),
            ],
        ];

        return response()->json([
            'success' => true,
            'data' => $stats,
        ]);
    }

    /**
     * Clone workflow.
     */
    public function clone(Workflow $workflow): JsonResponse
    {
        $clonedWorkflow = $workflow->replicate();
        $clonedWorkflow->name = $clonedWorkflow->name . ' (Copie)';
        $clonedWorkflow->status = 'draft';
        $clonedWorkflow->is_active = false;
        $clonedWorkflow->created_by = auth()->id();
        $clonedWorkflow->save();

        return response()->json([
            'success' => true,
            'message' => 'Workflow cloned successfully',
            'data' => $clonedWorkflow->load('creator'),
        ]);
    }
}
