<?php

namespace Database\Factories;

use App\Models\User;
use App\Models\Project;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Project>
 */
class ProjectFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = Project::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $startDate = $this->faker->dateTimeBetween('now', '+2 months');
        $endDate = $this->faker->dateTimeBetween($startDate, '+6 months');

        return [
            'name' => $this->faker->randomElement([
                'Projet ' . $this->faker->randomElement(['Marketing', 'Digital', 'E-commerce', 'Mobile', 'Web', 'IoT', 'AI', 'Cloud', 'Security', 'Analytics']),
                'Développement ' . $this->faker->randomElement(['Application', 'Site Web', 'API', 'Dashboard', 'Portail', 'Système']),
                'Migration ' . $this->faker->randomElement(['Base de données', 'Infrastructure', 'Applications', 'Système']),
                'Optimisation ' . $this->faker->randomElement(['Performance', 'Processus', 'Workflow', 'Système']),
                'Intégration ' . $this->faker->randomElement(['API', 'Système', 'Service', 'Plateforme'])
            ]) . ' ' . $this->faker->company(),
            'description' => $this->faker->paragraphs(rand(2, 4), true),
            'type' => $this->faker->randomElement(['residential', 'commercial', 'industrial']),
            'start_date' => $startDate,
            'end_date' => $endDate,
            'budget' => $this->faker->randomFloat(2, 5000, 500000),
            'status' => $this->faker->randomElement(['planning', 'in_progress', 'on_hold', 'completed', 'cancelled']),
            'priority' => $this->faker->randomElement(['low', 'medium', 'high', 'critical']),
            'client_name' => $this->faker->company(),
            'client_email' => $this->faker->companyEmail(),
            'client_phone' => $this->faker->phoneNumber(),
            'location' => $this->faker->randomElement([
                'Paris, France',
                'Lyon, France',
                'Marseille, France',
                'Toulouse, France',
                'Nantes, France',
                'Strasbourg, France',
                'Montpellier, France',
                'Bordeaux, France',
                'Lille, France',
                'Rennes, France'
            ]),
            'manager_id' => User::factory(),
            'team_members' => null,
            'progress' => $this->faker->numberBetween(0, 100),
            'tags' => json_encode($this->faker->optional()->randomElements([
                'urgent',
                'stratégique',
                'innovation',
                'digital',
                'transformation',
                'migration',
                'optimisation',
                'intégration',
                'développement',
                'maintenance',
                'support',
                'formation',
                'consulting'
            ], rand(1, 4))),
            'attachments' => json_encode($this->faker->optional()->randomElements([
                'documents/projet_plan.pdf',
                'documents/cahier_charges.docx',
                'documents/budget_detaille.xlsx',
                'images/logo_client.png',
                'images/site_avant.jpg',
                'documents/rapport_analyse.pdf'
            ], rand(0, 3))),
            'created_at' => $this->faker->dateTimeBetween('-6 months', 'now'),
            'updated_at' => function (array $attributes) {
                return $this->faker->dateTimeBetween($attributes['created_at'], 'now');
            },
        ];
    }

    /**
     * Indicate that the project is in planning phase.
     */
    public function planning(): static
    {
        return $this->state(fn(array $attributes) => [
            'status' => 'planning',
            'progress' => 0,
            'start_date' => $this->faker->dateTimeBetween('+1 month', '+3 months'),
            'end_date' => $this->faker->dateTimeBetween('+4 months', '+8 months'),
        ]);
    }

    /**
     * Indicate that the project is in progress.
     */
    public function inProgress(): static
    {
        return $this->state(fn(array $attributes) => [
            'status' => 'in_progress',
            'progress' => $this->faker->numberBetween(10, 80),
            'start_date' => $this->faker->dateTimeBetween('-2 months', '-1 month'),
            'end_date' => $this->faker->dateTimeBetween('+1 month', '+4 months'),
        ]);
    }

    /**
     * Indicate that the project is on hold.
     */
    public function onHold(): static
    {
        return $this->state(fn(array $attributes) => [
            'status' => 'on_hold',
            'progress' => $this->faker->numberBetween(20, 60),
            'start_date' => $this->faker->dateTimeBetween('-3 months', '-1 month'),
            'end_date' => $this->faker->dateTimeBetween('+2 months', '+6 months'),
        ]);
    }

    /**
     * Indicate that the project is completed.
     */
    public function completed(): static
    {
        return $this->state(fn(array $attributes) => [
            'status' => 'completed',
            'progress' => 100,
            'start_date' => $this->faker->dateTimeBetween('-6 months', '-3 months'),
            'end_date' => $this->faker->dateTimeBetween('-2 months', '-1 month'),
        ]);
    }

    /**
     * Indicate that the project is cancelled.
     */
    public function cancelled(): static
    {
        return $this->state(fn(array $attributes) => [
            'status' => 'cancelled',
            'progress' => $this->faker->numberBetween(0, 40),
            'start_date' => $this->faker->dateTimeBetween('-4 months', '-2 months'),
            'end_date' => $this->faker->dateTimeBetween('-1 month', 'now'),
        ]);
    }

    /**
     * Indicate that the project has high priority.
     */
    public function highPriority(): static
    {
        return $this->state(fn(array $attributes) => [
            'priority' => 'high',
        ]);
    }

    /**
     * Indicate that the project has critical priority.
     */
    public function criticalPriority(): static
    {
        return $this->state(fn(array $attributes) => [
            'priority' => 'critical',
        ]);
    }

    /**
     * Indicate that the project has a large budget.
     */
    public function largeBudget(): static
    {
        return $this->state(fn(array $attributes) => [
            'budget' => $this->faker->randomFloat(2, 100000, 1000000),
        ]);
    }

    /**
     * Indicate that the project has a small budget.
     */
    public function smallBudget(): static
    {
        return $this->state(fn(array $attributes) => [
            'budget' => $this->faker->randomFloat(2, 1000, 25000),
        ]);
    }

    /**
     * Indicate that the project is urgent.
     */
    public function urgent(): static
    {
        return $this->state(fn(array $attributes) => [
            'priority' => 'critical',
            'status' => 'in_progress',
            'start_date' => $this->faker->dateTimeBetween('-1 week', 'now'),
            'end_date' => $this->faker->dateTimeBetween('+1 week', '+1 month'),
            'tags' => json_encode(array_merge($this->faker->randomElements(['urgent', 'stratégique'], 1), ['deadline']))
        ]);
    }

    /**
     * Indicate that the project is strategic.
     */
    public function strategic(): static
    {
        return $this->state(fn(array $attributes) => [
            'priority' => 'high',
            'budget' => $this->faker->randomFloat(2, 50000, 500000),
            'tags' => json_encode(array_merge($this->faker->randomElements(['stratégique', 'innovation'], 1), ['long-term', 'business-critical']))
        ]);
    }
}
