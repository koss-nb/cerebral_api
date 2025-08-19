<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Delivery;
use App\Models\Material;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

class DeliveryController extends Controller
{
    /**
     * @OA\Get(
     *     path="/deliveries",
     *     summary="Liste des livraisons",
     *     tags={"Livraisons"},
     *     @OA\Parameter(
     *         name="status",
     *         in="query",
     *         required=false,
     *         @OA\Schema(type="string"),
     *         description="Filtrer par statut"
     *     ),
     *     @OA\Parameter(
     *         name="project_id",
     *         in="query",
     *         required=false,
     *         @OA\Schema(type="integer"),
     *         description="Filtrer par projet"
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Liste des livraisons",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="data", type="array", @OA\Items(type="object"))
     *         )
     *     )
     * )
     */
    public function index(Request $request): JsonResponse
    {
        $query = Delivery::with(['project', 'createdBy', 'receivedBy', 'materials']);

        if ($request->status) {
            $query->where('status', $request->status);
        }

        if ($request->project_id) {
            $query->where('project_id', $request->project_id);
        }

        $deliveries = $query->orderBy('expected_date', 'desc')->paginate(20);

        return response()->json([
            'success' => true,
            'data' => $deliveries,
        ]);
    }

    /**
     * @OA\Post(
     *     path="/deliveries",
     *     summary="Créer une livraison",
     *     tags={"Livraisons"},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             required={"title", "supplier", "expected_date"},
     *             @OA\Property(property="title", type="string", example="Livraison ciment", description="Titre de la livraison"),
     *             @OA\Property(property="description", type="string", example="Livraison de ciment pour Villa A3", description="Description"),
     *             @OA\Property(property="project_id", type="integer", example=1, description="ID du projet"),
     *             @OA\Property(property="supplier", type="string", example="Fournisseur BTP", description="Fournisseur"),
     *             @OA\Property(property="supplier_contact", type="string", example="contact@btp.fr", description="Contact fournisseur"),
     *             @OA\Property(property="expected_date", type="string", format="date", example="2024-03-28", description="Date de livraison prévue"),
     *             @OA\Property(property="notes", type="string", example="Livraison matin", description="Notes"),
     *             @OA\Property(property="materials", type="array", @OA\Items(type="object"), description="Liste des matériaux")
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Livraison créée",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Livraison créée avec succès"),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'project_id' => 'nullable|exists:projects,id',
            'supplier' => 'required|string|max:255',
            'supplier_contact' => 'nullable|string|max:255',
            'expected_date' => 'required|date|after:today',
            'notes' => 'nullable|string',
            'materials' => 'nullable|array',
            'materials.*.material_id' => 'required_with:materials|exists:materials,id',
            'materials.*.quantity' => 'required_with:materials|numeric|min:0.01',
            'materials.*.notes' => 'nullable|string',
        ]);

        $delivery = Delivery::create([
            'reference' => 'DEL-' . strtoupper(Str::random(8)),
            'title' => $request->title,
            'description' => $request->description,
            'project_id' => $request->project_id,
            'supplier' => $request->supplier,
            'supplier_contact' => $request->supplier_contact,
            'expected_date' => $request->expected_date,
            'notes' => $request->notes,
            'created_by' => Auth::id(),
        ]);

        // Attacher les matériaux si fournis
        if ($request->materials) {
            foreach ($request->materials as $materialData) {
                $delivery->materials()->attach($materialData['material_id'], [
                    'quantity' => $materialData['quantity'],
                    'notes' => $materialData['notes'] ?? null,
                ]);
            }
        }

        return response()->json([
            'success' => true,
            'message' => 'Livraison créée avec succès',
            'data' => $delivery->load(['project', 'createdBy', 'materials']),
        ]);
    }

    /**
     * @OA\Get(
     *     path="/deliveries/{delivery}",
     *     summary="Détails d'une livraison",
     *     tags={"Livraisons"},
     *     @OA\Parameter(
     *         name="delivery",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID de la livraison"
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Détails de la livraison",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function show(Delivery $delivery): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => $delivery->load(['project', 'createdBy', 'receivedBy', 'materials']),
        ]);
    }

    /**
     * @OA\Put(
     *     path="/deliveries/{delivery}",
     *     summary="Modifier une livraison",
     *     tags={"Livraisons"},
     *     @OA\Parameter(
     *         name="delivery",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID de la livraison"
     *     ),
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             @OA\Property(property="title", type="string", example="Livraison ciment modifiée"),
     *             @OA\Property(property="expected_date", type="string", format="date", example="2024-03-29"),
     *             @OA\Property(property="status", type="string", example="confirmed")
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Livraison modifiée",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Livraison modifiée avec succès"),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function update(Request $request, Delivery $delivery): JsonResponse
    {
        $request->validate([
            'title' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'project_id' => 'sometimes|exists:projects,id',
            'supplier' => 'sometimes|string|max:255',
            'supplier_contact' => 'nullable|string|max:255',
            'expected_date' => 'sometimes|date',
            'status' => 'sometimes|in:pending,confirmed,in_transit,delivered,cancelled',
            'notes' => 'nullable|string',
        ]);

        $delivery->update($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Livraison modifiée avec succès',
            'data' => $delivery->load(['project', 'createdBy', 'materials']),
        ]);
    }

    /**
     * @OA\Delete(
     *     path="/deliveries/{delivery}",
     *     summary="Supprimer une livraison",
     *     tags={"Livraisons"},
     *     @OA\Parameter(
     *         name="delivery",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID de la livraison"
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Livraison supprimée",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Livraison supprimée avec succès")
     *         )
     *     )
     * )
     */
    public function destroy(Delivery $delivery): JsonResponse
    {
        $delivery->delete();

        return response()->json([
            'success' => true,
            'message' => 'Livraison supprimée avec succès',
        ]);
    }

    /**
     * @OA\Post(
     *     path="/deliveries/{delivery}/receive",
     *     summary="Réceptionner une livraison",
     *     tags={"Livraisons"},
     *     @OA\Parameter(
     *         name="delivery",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID de la livraison"
     *     ),
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             @OA\Property(property="received_materials", type="array", @OA\Items(type="object"), description="Matériaux reçus")
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Livraison réceptionnée",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Livraison réceptionnée"),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     *     )
     */
    public function receive(Request $request, Delivery $delivery): JsonResponse
    {
        $request->validate([
            'received_materials' => 'required|array',
            'received_materials.*.material_id' => 'required|exists:materials,id',
            'received_materials.*.received_quantity' => 'required|numeric|min:0.01',
        ]);

        if ($delivery->isDelivered()) {
            return response()->json([
                'success' => false,
                'message' => 'Cette livraison a déjà été réceptionnée',
            ], 400);
        }

        // Mettre à jour les quantités reçues et le stock
        foreach ($request->received_materials as $receivedMaterial) {
            $material = Material::find($receivedMaterial['material_id']);
            
            // Mettre à jour la quantité reçue dans la table pivot
            $delivery->materials()->updateExistingPivot($receivedMaterial['material_id'], [
                'received_quantity' => $receivedMaterial['received_quantity'],
            ]);

            // Mettre à jour le stock du matériau
            $material->updateStock($receivedMaterial['received_quantity'], 'add');
        }

        // Marquer la livraison comme livrée
        $delivery->markAsDelivered(Auth::id());

        return response()->json([
            'success' => true,
            'message' => 'Livraison réceptionnée avec succès',
            'data' => $delivery->load(['project', 'createdBy', 'receivedBy', 'materials']),
        ]);
    }

    /**
     * @OA\Post(
     *     path="/deliveries/{delivery}/confirm",
     *     summary="Confirmer une livraison",
     *     tags={"Livraisons"},
     *     @OA\Parameter(
     *         name="delivery",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID de la livraison"
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Livraison confirmée",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Livraison confirmée"),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function confirm(Delivery $delivery): JsonResponse
    {
        if (!$delivery->isPending()) {
            return response()->json([
                'success' => false,
                'message' => 'Cette livraison ne peut pas être confirmée',
            ], 400);
        }

        $delivery->update(['status' => 'confirmed']);

        return response()->json([
            'success' => true,
            'message' => 'Livraison confirmée',
            'data' => $delivery->load(['project', 'createdBy', 'materials']),
        ]);
    }

    /**
     * @OA\Get(
     *     path="/deliveries/upcoming",
     *     summary="Livraisons à venir",
     *     tags={"Livraisons"},
     *     @OA\Response(
     *         response=200,
     *         description="Livraisons à venir",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="data", type="array", @OA\Items(type="object"))
     *         )
     *     )
     * )
     */
    public function upcoming(): JsonResponse
    {
        $upcomingDeliveries = Delivery::where('status', 'pending')
            ->orWhere('status', 'confirmed')
            ->where('expected_date', '>=', now())
            ->with(['project', 'createdBy', 'materials'])
            ->orderBy('expected_date')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $upcomingDeliveries,
        ]);
    }
}
