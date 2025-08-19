<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Media;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class MediaController extends Controller
{
    /**
     * @OA\Post(
     *     path="/media/upload",
     *     summary="Upload de fichier",
     *     tags={"Médias"},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\MediaType(
     *             mediaType="multipart/form-data",
     *             @OA\Schema(
     *                 required={"file", "mediable_type", "mediable_id"},
     *                 @OA\Property(property="file", type="string", format="binary", description="Fichier à uploader"),
     *                 @OA\Property(property="mediable_type", type="string", example="App\\Models\\Task", description="Type du modèle parent"),
     *                 @OA\Property(property="mediable_id", type="integer", example=1, description="ID du modèle parent"),
     *                 @OA\Property(property="title", type="string", example="Photo validation", description="Titre du média"),
     *                 @OA\Property(property="description", type="string", example="Photo de validation de la tâche", description="Description"),
     *                 @OA\Property(property="category", type="string", example="validation", description="Catégorie du média")
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Fichier uploadé",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Fichier uploadé avec succès"),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function upload(Request $request): JsonResponse
    {
        $request->validate([
            'file' => 'required|file|max:10240', // 10MB max
            'mediable_type' => 'required|string',
            'mediable_id' => 'required|integer',
            'title' => 'nullable|string|max:255',
            'description' => 'nullable|string',
            'category' => 'nullable|string|max:100',
        ]);

        // Vérifier que le modèle parent existe
        if (!class_exists($request->mediable_type)) {
            throw ValidationException::withMessages([
                'mediable_type' => 'Type de modèle invalide'
            ]);
        }

        $parentModel = $request->mediable_type::find($request->mediable_id);
        if (!$parentModel) {
            throw ValidationException::withMessages([
                'mediable_id' => 'Modèle parent introuvable'
            ]);
        }

        $file = $request->file('file');
        $originalName = $file->getClientOriginalName();
        $extension = $file->getClientOriginalExtension();
        $mimeType = $file->getMimeType();
        $fileSize = $file->getSize();

        // Déterminer le type de média
        $type = $this->getMediaType($mimeType);

        // Générer un nom de fichier unique
        $filename = Str::uuid() . '.' . $extension;
        $filePath = 'media/' . date('Y/m/d') . '/' . $filename;

        // Stocker le fichier
        Storage::disk('public')->put($filePath, file_get_contents($file));

        // Créer l'enregistrement en base
        $media = Media::create([
            'filename' => $filename,
            'original_name' => $originalName,
            'mime_type' => $mimeType,
            'extension' => $extension,
            'file_size' => $fileSize,
            'file_path' => $filePath,
            'url' => asset('storage/' . $filePath),
            'title' => $request->title ?? $originalName,
            'description' => $request->description,
            'type' => $type,
            'category' => $request->category,
            'uploaded_by' => Auth::id(),
            'mediable_type' => $request->mediable_type,
            'mediable_id' => $request->mediable_id,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Fichier uploadé avec succès',
            'data' => $media->load('uploadedBy'),
        ]);
    }

    /**
     * @OA\Get(
     *     path="/media",
     *     summary="Liste des médias",
     *     tags={"Médias"},
     *     @OA\Parameter(
     *         name="type",
     *         in="query",
     *         required=false,
     *         @OA\Schema(type="string"),
     *         description="Filtrer par type"
     *     ),
     *     @OA\Parameter(
     *         name="category",
     *         in="query",
     *         required=false,
     *         @OA\Schema(type="string"),
     *         description="Filtrer par catégorie"
     *     ),
     *     @OA\Parameter(
     *         name="mediable_type",
     *         in="query",
     *         required=false,
     *         @OA\Schema(type="string"),
     *         description="Filtrer par type de modèle parent"
     *     ),
     *     @OA\Parameter(
     *         name="mediable_id",
     *         in="query",
     *         required=false,
     *         @OA\Schema(type="integer"),
     *         description="Filtrer par ID du modèle parent"
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Liste des médias",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="data", type="array", @OA\Items(type="object"))
     *         )
     *     )
     * )
     */
    public function index(Request $request): JsonResponse
    {
        $query = Media::with(['uploadedBy']);

        if ($request->type) {
            $query->ofType($request->type);
        }

        if ($request->category) {
            $query->ofCategory($request->category);
        }

        if ($request->mediable_type) {
            $query->where('mediable_type', $request->mediable_type);
        }

        if ($request->mediable_id) {
            $query->where('mediable_id', $request->mediable_id);
        }

        $media = $query->orderBy('created_at', 'desc')->paginate(20);

        return response()->json([
            'success' => true,
            'data' => $media,
        ]);
    }

    /**
     * @OA\Get(
     *     path="/media/{media}",
     *     summary="Détails d'un média",
     *     tags={"Médias"},
     *     @OA\Parameter(
     *         name="media",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID du média"
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Détails du média",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function show(Media $media): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => $media->load(['uploadedBy']),
        ]);
    }

    /**
     * @OA\Put(
     *     path="/media/{media}",
     *     summary="Modifier un média",
     *     tags={"Médias"},
     *     @OA\Parameter(
     *         name="media",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID du média"
     *     ),
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             @OA\Property(property="title", type="string", example="Nouveau titre"),
     *             @OA\Property(property="description", type="string", example="Nouvelle description"),
     *             @OA\Property(property="category", type="string", example="nouvelle_categorie")
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Média modifié",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Média modifié avec succès"),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function update(Request $request, Media $media): JsonResponse
    {
        $request->validate([
            'title' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'category' => 'sometimes|string|max:100',
        ]);

        $media->update($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Média modifié avec succès',
            'data' => $media->load('uploadedBy'),
        ]);
    }

    /**
     * @OA\Delete(
     *     path="/media/{media}",
     *     summary="Supprimer un média",
     *     tags={"Médias"},
     *     @OA\Parameter(
     *         name="media",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID du média"
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Média supprimé",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Média supprimé avec succès")
     *         )
     *     )
     * )
     */
    public function destroy(Media $media): JsonResponse
    {
        // Supprimer le fichier physique
        if (Storage::disk('public')->exists($media->file_path)) {
            Storage::disk('public')->delete($media->file_path);
        }

        $media->delete();

        return response()->json([
            'success' => true,
            'message' => 'Média supprimé avec succès',
        ]);
    }

    /**
     * @OA\Get(
     *     path="/media/task/{taskId}",
     *     summary="Médias d'une tâche",
     *     tags={"Médias"},
     *     @OA\Parameter(
     *         name="taskId",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID de la tâche"
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Médias de la tâche",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="data", type="array", @OA\Items(type="object"))
     *         )
     *     )
     * )
     */
    public function taskMedia(int $taskId): JsonResponse
    {
        $media = Media::where('mediable_type', 'App\\Models\\Task')
            ->where('mediable_id', $taskId)
            ->with(['uploadedBy'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $media,
        ]);
    }

    /**
     * @OA\Get(
     *     path="/media/project/{projectId}",
     *     summary="Médias d'un projet",
     *     tags={"Médias"},
     *     @OA\Parameter(
     *         name="projectId",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID du projet"
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Médias du projet",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="data", type="array", @OA\Items(type="object"))
     *         )
     *     )
     * )
     */
    public function projectMedia(int $projectId): JsonResponse
    {
        $media = Media::where('mediable_type', 'App\\Models\\Project')
            ->where('mediable_id', $projectId)
            ->with(['uploadedBy'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $media,
        ]);
    }

    /**
     * Déterminer le type de média basé sur le MIME type
     */
    private function getMediaType(string $mimeType): string
    {
        if (Str::startsWith($mimeType, 'image/')) {
            return 'image';
        } elseif (Str::startsWith($mimeType, 'video/')) {
            return 'video';
        } elseif (Str::startsWith($mimeType, 'audio/')) {
            return 'audio';
        } else {
            return 'document';
        }
    }
}
