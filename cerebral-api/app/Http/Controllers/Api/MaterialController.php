<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Material;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class MaterialController extends Controller
{
    /**
     * @OA\Get(
     *     path="/materials",
     *     summary="Liste des matériaux",
     *     tags={"Matériaux"},
     *     @OA\Parameter(
     *         name="category",
     *         in="query",
     *         required=false,
     *         @OA\Schema(type="string"),
     *         description="Filtrer par catégorie"
     *     ),
     *     @OA\Parameter(
     *         name="status",
     *         in="query",
     *         required=false,
     *         @OA\Schema(type="string"),
     *         description="Filtrer par statut"
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Liste des matériaux",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="data", type="array", @OA\Items(type="object"))
     *         )
     *     )
     * )
     */
    public function index(Request $request): JsonResponse
    {
        $query = Material::with(['createdBy']);

        if ($request->category) {
            $query->where('category', $request->category);
        }

        if ($request->status) {
            $query->where('status', $request->status);
        }

        $materials = $query->orderBy('name')->paginate(20);

        return response()->json([
            'success' => true,
            'data' => $materials,
        ]);
    }

    /**
     * @OA\Post(
     *     path="/materials",
     *     summary="Créer un matériau",
     *     tags={"Matériaux"},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             required={"name", "category", "unit", "current_stock", "min_stock"},
     *             @OA\Property(property="name", type="string", example="Ciment", description="Nom du matériau"),
     *             @OA\Property(property="description", type="string", example="Ciment Portland", description="Description"),
     *             @OA\Property(property="category", type="string", example="construction", description="Catégorie"),
     *             @OA\Property(property="unit", type="string", example="sac", description="Unité de mesure"),
     *             @OA\Property(property="current_stock", type="number", example=100, description="Stock actuel"),
     *             @OA\Property(property="min_stock", type="number", example=20, description="Stock minimum"),
     *             @OA\Property(property="max_stock", type="number", example=200, description="Stock maximum"),
     *             @OA\Property(property="unit_price", type="number", example=15.50, description="Prix unitaire"),
     *             @OA\Property(property="supplier", type="string", example="Fournisseur BTP", description="Fournisseur"),
     *             @OA\Property(property="location", type="string", example="Entrepôt A", description="Localisation")
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Matériau créé",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Matériau créé avec succès"),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'category' => 'required|string|max:100',
            'unit' => 'required|string|max:50',
            'current_stock' => 'required|numeric|min:0',
            'min_stock' => 'required|numeric|min:0',
            'max_stock' => 'nullable|numeric|min:0',
            'unit_price' => 'nullable|numeric|min:0',
            'supplier' => 'nullable|string|max:255',
            'supplier_contact' => 'nullable|string|max:255',
            'location' => 'nullable|string|max:255',
        ]);

        $material = Material::create([
            ...$request->all(),
            'created_by' => Auth::id(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Matériau créé avec succès',
            'data' => $material->load('createdBy'),
        ]);
    }

    /**
     * @OA\Get(
     *     path="/materials/{material}",
     *     summary="Détails d'un matériau",
     *     tags={"Matériaux"},
     *     @OA\Parameter(
     *         name="material",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID du matériau"
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Détails du matériau",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function show(Material $material): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => $material->load(['createdBy', 'deliveries']),
        ]);
    }

    /**
     * @OA\Put(
     *     path="/materials/{material}",
     *     summary="Modifier un matériau",
     *     tags={"Matériaux"},
     *     @OA\Parameter(
     *         name="material",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID du matériau"
     *     ),
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             @OA\Property(property="name", type="string", example="Ciment Portland"),
     *             @OA\Property(property="current_stock", type="number", example=150),
     *             @OA\Property(property="unit_price", type="number", example=16.00)
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Matériau modifié",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Matériau modifié avec succès"),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function update(Request $request, Material $material): JsonResponse
    {
        $request->validate([
            'name' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'category' => 'sometimes|string|max:100',
            'unit' => 'sometimes|string|max:50',
            'current_stock' => 'sometimes|numeric|min:0',
            'min_stock' => 'sometimes|numeric|min:0',
            'max_stock' => 'nullable|numeric|min:0',
            'unit_price' => 'nullable|numeric|min:0',
            'supplier' => 'nullable|string|max:255',
            'supplier_contact' => 'nullable|string|max:255',
            'location' => 'nullable|string|max:255',
        ]);

        $material->update($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Matériau modifié avec succès',
            'data' => $material->load('createdBy'),
        ]);
    }

    /**
     * @OA\Delete(
     *     path="/materials/{material}",
     *     summary="Supprimer un matériau",
     *     tags={"Matériaux"},
     *     @OA\Parameter(
     *         name="material",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID du matériau"
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Matériau supprimé",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Matériau supprimé avec succès")
     *         )
     *     )
     * )
     */
    public function destroy(Material $material): JsonResponse
    {
        $material->delete();

        return response()->json([
            'success' => true,
            'message' => 'Matériau supprimé avec succès',
        ]);
    }

    /**
     * @OA\Get(
     *     path="/materials/low-stock",
     *     summary="Matériaux en stock faible",
     *     tags={"Matériaux"},
     *     @OA\Response(
     *         response=200,
     *         description="Matériaux en stock faible",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="data", type="array", @OA\Items(type="object"))
     *         )
     *     )
     * )
     */
    public function lowStock(): JsonResponse
    {
        $lowStockMaterials = Material::where('status', 'low_stock')
            ->orWhere('status', 'out_of_stock')
            ->with('createdBy')
            ->orderBy('current_stock')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $lowStockMaterials,
        ]);
    }

    /**
     * @OA\Post(
     *     path="/materials/{material}/update-stock",
     *     summary="Mettre à jour le stock d'un matériau",
     *     tags={"Matériaux"},
     *     @OA\Parameter(
     *         name="material",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID du matériau"
     *     ),
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             required={"quantity", "operation"},
     *             @OA\Property(property="quantity", type="number", example=50, description="Quantité"),
     *             @OA\Property(property="operation", type="string", example="add", description="Opération (add/subtract)")
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Stock mis à jour",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Stock mis à jour"),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function updateStock(Request $request, Material $material): JsonResponse
    {
        $request->validate([
            'quantity' => 'required|numeric|min:0.01',
            'operation' => 'required|in:add,subtract',
        ]);

        $material->updateStock($request->quantity, $request->operation);

        return response()->json([
            'success' => true,
            'message' => 'Stock mis à jour',
            'data' => $material->load('createdBy'),
        ]);
    }
}
