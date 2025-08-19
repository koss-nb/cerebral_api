<?php

namespace Database\Factories;

use App\Models\User;
use App\Models\Project;
use App\Models\Task;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Task>
 */
class TaskFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = Task::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $startDate = $this->faker->dateTimeBetween('now', '+1 month');
        $dueDate = $this->faker->dateTimeBetween($startDate, '+2 months');
        
        return [
            'title' => $this->faker->randomElement([
                'Développer ' . $this->faker->randomElement(['interface utilisateur', 'API REST', 'base de données', 'système de notification', 'dashboard admin']),
                'Corriger ' . $this->faker->randomElement(['bug de connexion', 'erreur de validation', 'problème de performance', 'bug d\'affichage']),
                'Améliorer ' . $this->faker->randomElement(['temps de réponse', 'interface mobile', 'sécurité', 'accessibilité']),
                'Documenter ' . $this->faker->randomElement(['API endpoints', 'guide utilisateur', 'architecture système', 'procédures de déploiement']),
                'Tester ' . $this->faker->randomElement(['fonctionnalités', 'intégration', 'performance', 'sécurité'])
            ]),
            'description' => $this->faker->paragraphs(rand(2, 4), true),
            'project_id' => Project::factory(),
            'assigned_to' => User::factory(),
            'status' => $this->faker->randomElement(['pending', 'in_progress', 'review', 'completed', 'cancelled']),
            'priority' => $this->faker->randomElement(['low', 'medium', 'high', 'critical']),
            'estimated_hours' => $this->faker->randomFloat(1, 1, 40),
            'actual_hours' => $this->faker->optional()->randomFloat(1, 0, 50),
            'start_date' => $startDate,
            'due_date' => $dueDate,
            'completed_at' => $this->faker->optional()->dateTimeBetween($startDate, $dueDate),
            'progress' => $this->faker->numberBetween(0, 100),
            'attachments' => $this->faker->optional()->randomElements([
                'documents/specification.pdf',
                'images/mockup.png',
                'documents/requirements.docx',
                'images/screenshot.jpg',
                'documents/test-plan.xlsx'
            ], rand(0, 3)),
            'created_by' => User::factory(),
            'created_at' => $this->faker->dateTimeBetween('-3 months', 'now'),
            'updated_at' => function (array $attributes) {
                return $this->faker->dateTimeBetween($attributes['created_at'], 'now');
            },
        ];
    }

    /**
     * Indicate that the task is pending.
     */
    public function pending(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'pending',
            'progress' => 0,
            'start_date' => $this->faker->dateTimeBetween('+1 week', '+2 weeks'),
            'due_date' => $this->faker->dateTimeBetween('+3 weeks', '+1 month'),
        ]);
    }

    /**
     * Indicate that the task is in progress.
     */
    public function inProgress(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'in_progress',
            'progress' => $this->faker->numberBetween(10, 80),
            'start_date' => $this->faker->dateTimeBetween('-1 week', 'now'),
            'due_date' => $this->faker->dateTimeBetween('+1 week', '+3 weeks'),
        ]);
    }

    /**
     * Indicate that the task is in review.
     */
    public function inReview(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'review',
            'progress' => $this->faker->numberBetween(80, 95),
            'start_date' => $this->faker->dateTimeBetween('-2 weeks', '-1 week'),
            'due_date' => $this->faker->dateTimeBetween('+1 week', '+2 weeks'),
        ]);
    }

    /**
     * Indicate that the task is completed.
     */
    public function completed(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'completed',
            'progress' => 100,
            'start_date' => $this->faker->dateTimeBetween('-1 month', '-2 weeks'),
            'due_date' => $this->faker->dateTimeBetween('-2 weeks', '-1 week'),
            'completed_at' => $this->faker->dateTimeBetween('-1 week', 'now'),
        ]);
    }

    /**
     * Indicate that the task is urgent.
     */
    public function urgent(): static
    {
        return $this->state(fn (array $attributes) => [
            'priority' => 'critical',
            'status' => 'in_progress',
            'start_date' => $this->faker->dateTimeBetween('-1 day', 'now'),
            'due_date' => $this->faker->dateTimeBetween('+1 day', '+1 week'),
        ]);
    }

    /**
     * Indicate that the task is overdue.
     */
    public function overdue(): static
    {
        return $this->state(fn (array $attributes) => [
            'due_date' => $this->faker->dateTimeBetween('-2 weeks', '-1 day'),
            'status' => $this->faker->randomElement(['pending', 'in_progress']),
        ]);
    }
}
