<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\PersonnelRequest;
use App\Http\Resources\PersonnelResource;
use App\Models\Personnel;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class PersonnelController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request): JsonResponse
    {
        $query = Personnel::with(['creator', 'manager', 'subordinates']);

        // Filtres
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('department')) {
            $query->where('department', $request->department);
        }

        if ($request->has('position')) {
            $query->where('position', $request->position);
        }

        if ($request->has('contract_type')) {
            $query->where('contract_type', $request->contract_type);
        }

        if ($request->has('manager_id')) {
            $query->where('manager_id', $request->manager_id);
        }

        // Recherche
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('first_name', 'like', "%{$search}%")
                    ->orWhere('last_name', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%")
                    ->orWhere('employee_id', 'like', "%{$search}%")
                    ->orWhere('position', 'like', "%{$search}%");
            });
        }

        // Tri
        $sortBy = $request->get('sort_by', 'hire_date');
        $sortOrder = $request->get('sort_order', 'desc');
        $query->orderBy($sortBy, $sortOrder);

        $personnel = $query->paginate($request->get('per_page', 15));

        return response()->json([
            'success' => true,
            'data' => PersonnelResource::collection($personnel),
            'meta' => [
                'current_page' => $personnel->currentPage(),
                'last_page' => $personnel->lastPage(),
                'per_page' => $personnel->perPage(),
                'total' => $personnel->total(),
            ],
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(PersonnelRequest $request): JsonResponse
    {
        try {
            DB::beginTransaction();

            // Préparer les données avec les valeurs par défaut
            $personnelData = $request->validated();
            $personnelData['contract_type'] = $personnelData['contract_type'] ?? 'full_time';
            $personnelData['created_by'] = 1; // ID de l'admin par défaut

            // Créer le personnel
            $personnel = Personnel::create($personnelData);

            // Créer automatiquement un compte utilisateur pour ce personnel
            $userData = [
                'first_name' => $personnel->first_name,
                'last_name' => $personnel->last_name,
                'email' => $personnel->email,
                'password' => bcrypt($personnel->phone), // Utiliser le numéro de téléphone comme mot de passe
                'role' => $request->input('role', 'technicien'), // Rôle par défaut
                'phone_number' => $personnel->phone,
                'department' => $personnel->department,
                'is_active' => true,
            ];

            // Vérifier si l'email n'existe pas déjà dans la table users
            if (!User::where('email', $personnel->email)->exists()) {
                $user = User::create($userData);

                // Lier le personnel à l'utilisateur
                $personnel->update(['user_id' => $user->id]);
            }

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Personnel créé avec succès',
                'data' => new PersonnelResource($personnel->load(['creator', 'manager'])),
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Erreur lors de la création du personnel',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Personnel $personnel): JsonResponse
    {
        $personnel->load(['creator', 'manager', 'subordinates', 'projects', 'tasks']);

        return response()->json([
            'success' => true,
            'data' => new PersonnelResource($personnel),
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(PersonnelRequest $request, Personnel $personnel): JsonResponse
    {
        try {
            DB::beginTransaction();

            $personnel->update($request->validated());

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Personnel mis à jour avec succès',
                'data' => new PersonnelResource($personnel->load(['creator', 'manager'])),
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Erreur lors de la mise à jour du personnel',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Personnel $personnel): JsonResponse
    {
        try {
            DB::beginTransaction();

            // Vérifier s'il y a des subordonnés
            if ($personnel->subordinates()->count() > 0) {
                return response()->json([
                    'success' => false,
                    'message' => 'Impossible de supprimer ce personnel car il a des subordonnés',
                ], 422);
            }

            // Vérifier s'il y a des tâches assignées
            if ($personnel->tasks()->count() > 0) {
                return response()->json([
                    'success' => false,
                    'message' => 'Impossible de supprimer ce personnel car il a des tâches assignées',
                ], 422);
            }

            $personnel->delete();

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Personnel supprimé avec succès',
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Erreur lors de la suppression du personnel',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Update personnel status.
     */
    public function updateStatus(Request $request, Personnel $personnel): JsonResponse
    {
        $request->validate([
            'status' => 'required|in:active,inactive,on_leave,terminated',
        ]);

        $personnel->update(['status' => $request->status]);

        return response()->json([
            'success' => true,
            'message' => 'Statut du personnel mis à jour avec succès',
            'data' => new PersonnelResource($personnel->load(['creator', 'manager'])),
        ]);
    }

    /**
     * Update personnel skills.
     */
    public function updateSkills(Request $request, Personnel $personnel): JsonResponse
    {
        $request->validate([
            'skills' => 'required|array',
            'skills.*' => 'string|max:100',
        ]);

        $personnel->update(['skills' => $request->skills]);

        return response()->json([
            'success' => true,
            'message' => 'Compétences du personnel mises à jour avec succès',
            'data' => new PersonnelResource($personnel->load(['creator', 'manager'])),
        ]);
    }

    /**
     * Get personnel skills.
     */
    public function skills(Personnel $personnel): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => [
                'personnel_id' => $personnel->id,
                'name' => $personnel->full_name,
                'skills' => $personnel->skills ?? [],
                'certifications' => $personnel->certifications ?? [],
                'languages' => $personnel->languages ?? [],
            ],
        ]);
    }

    /**
     * Get personnel by department.
     */
    public function byDepartment(string $department): JsonResponse
    {
        $personnel = Personnel::with(['creator', 'manager'])
            ->where('department', $department)
            ->where('status', 'active')
            ->get();

        return response()->json([
            'success' => true,
            'data' => PersonnelResource::collection($personnel),
            'meta' => [
                'department' => $department,
                'count' => $personnel->count(),
            ],
        ]);
    }

    /**
     * Get personnel statistics.
     */
    public function stats(): JsonResponse
    {
        $stats = [
            'total' => Personnel::count(),
            'active' => Personnel::where('status', 'active')->count(),
            'inactive' => Personnel::where('status', 'inactive')->count(),
            'on_leave' => Personnel::where('status', 'on_leave')->count(),
            'terminated' => Personnel::where('status', 'terminated')->count(),
            'by_department' => Personnel::select('department', DB::raw('count(*) as count'))
                ->groupBy('department')
                ->get(),
            'by_contract_type' => Personnel::select('contract_type', DB::raw('count(*) as count'))
                ->groupBy('contract_type')
                ->get(),
            'average_salary' => Personnel::whereNotNull('salary')->avg('salary'),
            'average_age' => Personnel::whereNotNull('date_of_birth')->get()->avg('age'),
            'average_tenure' => Personnel::whereNotNull('hire_date')->get()->avg('tenure_years'),
        ];

        return response()->json([
            'success' => true,
            'data' => $stats,
        ]);
    }

    /**
     * Get personnel hierarchy.
     */
    public function hierarchy(): JsonResponse
    {
        $hierarchy = Personnel::with(['subordinates'])
            ->whereNull('manager_id')
            ->get()
            ->map(function ($manager) {
                return [
                    'id' => $manager->id,
                    'name' => $manager->full_name,
                    'position' => $manager->position,
                    'department' => $manager->department,
                    'subordinates' => $manager->subordinates->map(function ($subordinate) {
                        return [
                            'id' => $subordinate->id,
                            'name' => $subordinate->full_name,
                            'position' => $subordinate->position,
                            'department' => $subordinate->department,
                        ];
                    }),
                ];
            });

        return response()->json([
            'success' => true,
            'data' => $hierarchy,
        ]);
    }
}
