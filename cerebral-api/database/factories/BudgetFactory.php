<?php

namespace Database\Factories;

use App\Models\User;
use App\Models\Project;
use App\Models\Budget;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Budget>
 */
class BudgetFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = Budget::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $startDate = $this->faker->dateTimeBetween('now', '+1 month');
        $endDate = $this->faker->dateTimeBetween($startDate, '+6 months');
        $fiscalYear = $this->faker->numberBetween(2020, 2030);
        
        return [
            'project_id' => Project::factory(),
            'category' => $this->faker->randomElement([
                'Développement', 'Design', 'Infrastructure', 'Marketing', 'Formation',
                'Licences', 'Équipement', 'Services externes', 'Maintenance', 'Support'
            ]),
            'description' => $this->faker->paragraph(),
            'amount' => $this->faker->randomFloat(2, 1000, 100000),
            'currency' => $this->faker->randomElement(['EUR', 'USD', 'GBP']),
            'type' => $this->faker->randomElement(['income', 'expense', 'investment', 'loan', 'revenue', 'cost']),
            'status' => $this->faker->randomElement(['planned', 'approved', 'pending', 'rejected', 'executed', 'cancelled']),
            'fiscal_year' => $fiscalYear,
            'period' => $this->faker->randomElement(['monthly', 'quarterly', 'yearly', 'custom']),
            'start_date' => $startDate,
            'end_date' => $endDate,
            'approved_by' => User::factory(),
            'approved_at' => $this->faker->optional()->dateTimeBetween($startDate, $endDate),
            'payment_method' => $this->faker->randomElement(['Virement', 'Chèque', 'Carte bancaire', 'Espèces']),
            'payment_terms' => $this->faker->randomElement(['30 jours', '60 jours', 'Immédiat', 'À réception']),
            'due_date' => $this->faker->optional()->dateTimeBetween($startDate, $endDate),
            'vendor_supplier' => $this->faker->company(),
            'invoice_number' => $this->faker->optional()->regexify('INV-[0-9]{6}'),
            'reference_number' => $this->faker->optional()->regexify('REF-[0-9]{8}'),
            'tags' => $this->faker->optional()->randomElements([
                'urgent', 'stratégique', 'opérationnel', 'investissement', 'maintenance',
                'innovation', 'conformité', 'sécurité', 'performance', 'qualité'
            ], rand(1, 4)),
            'attachments' => $this->faker->optional()->randomElements([
                'documents/facture.pdf', 'documents/devis.pdf', 'documents/contrat.pdf',
                'images/screenshot.png', 'documents/specification.docx'
            ], rand(0, 3)),
            'notes' => $this->faker->optional()->paragraph(),
            'is_recurring' => $this->faker->boolean(20),
            'recurrence_pattern' => $this->faker->optional()->randomElement(['daily', 'weekly', 'monthly', 'quarterly', 'yearly']),
            'recurrence_end_date' => $this->faker->optional()->dateTimeBetween($endDate, '+2 years'),
            'budget_line_items' => $this->faker->optional()->randomElements([
                [
                    'description' => 'Licence logicielle',
                    'amount' => $this->faker->randomFloat(2, 100, 5000),
                    'category' => 'Licences',
                    'quantity' => 1,
                    'unit_price' => $this->faker->randomFloat(2, 100, 5000)
                ],
                [
                    'description' => 'Formation équipe',
                    'amount' => $this->faker->randomFloat(2, 2000, 15000),
                    'category' => 'Formation',
                    'quantity' => $this->faker->numberBetween(1, 10),
                    'unit_price' => $this->faker->randomFloat(2, 200, 1500)
                ]
            ], rand(0, 2)),
            'risk_level' => $this->faker->randomElement(['low', 'medium', 'high', 'critical']),
            'contingency_amount' => $this->faker->optional()->randomFloat(2, 100, 10000),
            'contingency_percentage' => $this->faker->optional()->randomFloat(2, 5, 25),
            'exchange_rate' => $this->faker->optional()->randomFloat(4, 0.8, 1.2),
            'base_currency' => $this->faker->optional()->randomElement(['EUR', 'USD', 'GBP']),
            'tax_rate' => $this->faker->optional()->randomFloat(2, 0, 25),
            'tax_amount' => $this->faker->optional()->randomFloat(2, 0, 5000),
            'discount_percentage' => $this->faker->optional()->randomFloat(2, 0, 15),
            'discount_amount' => $this->faker->optional()->randomFloat(2, 0, 3000),
            'total_amount' => $this->faker->optional()->randomFloat(2, 1000, 120000),
            'is_approved' => $this->faker->boolean(70),
            'is_executed' => $this->faker->boolean(30),
            'execution_date' => $this->faker->optional()->dateTimeBetween($startDate, $endDate),
            'execution_notes' => $this->faker->optional()->paragraph(),
            'variance_amount' => $this->faker->optional()->randomFloat(2, -5000, 5000),
            'variance_percentage' => $this->faker->optional()->randomFloat(2, -20, 20),
            'justification' => $this->faker->optional()->paragraph(),
            'approval_workflow' => $this->faker->optional()->randomElement([
                'Directeur → CFO → CEO', 'Manager → Directeur', 'Auto-approbation'
            ]),
            'next_review_date' => $this->faker->optional()->dateTimeBetween('now', '+3 months'),
            'review_frequency' => $this->faker->optional()->randomElement(['weekly', 'monthly', 'quarterly', 'yearly']),
            'created_by' => User::factory(),
            'created_at' => $this->faker->dateTimeBetween('-6 months', 'now'),
            'updated_at' => function (array $attributes) {
                return $this->faker->dateTimeBetween($attributes['created_at'], 'now');
            },
        ];
    }

    /**
     * Indicate that the budget is planned.
     */
    public function planned(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'planned',
            'is_approved' => false,
            'is_executed' => false,
        ]);
    }

    /**
     * Indicate that the budget is approved.
     */
    public function approved(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'approved',
            'is_approved' => true,
            'is_executed' => false,
            'approved_at' => $this->faker->dateTimeBetween('-1 month', 'now'),
        ]);
    }

    /**
     * Indicate that the budget is executed.
     */
    public function executed(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'executed',
            'is_approved' => true,
            'is_executed' => true,
            'execution_date' => $this->faker->dateTimeBetween('-1 month', 'now'),
        ]);
    }

    /**
     * Indicate that the budget is an income.
     */
    public function income(): static
    {
        return $this->state(fn (array $attributes) => [
            'type' => 'income',
            'amount' => $this->faker->randomFloat(2, 5000, 100000),
        ]);
    }

    /**
     * Indicate that the budget is an expense.
     */
    public function expense(): static
    {
        return $this->state(fn (array $attributes) => [
            'type' => 'expense',
            'amount' => $this->faker->randomFloat(2, 1000, 50000),
        ]);
    }

    /**
     * Indicate that the budget is high risk.
     */
    public function highRisk(): static
    {
        return $this->state(fn (array $attributes) => [
            'risk_level' => 'high',
            'contingency_percentage' => $this->faker->randomFloat(2, 15, 30),
        ]);
    }

    /**
     * Indicate that the budget is recurring.
     */
    public function recurring(): static
    {
        return $this->state(fn (array $attributes) => [
            'is_recurring' => true,
            'recurrence_pattern' => $this->faker->randomElement(['monthly', 'quarterly', 'yearly']),
        ]);
    }

    /**
     * Indicate that the budget is overdue.
     */
    public function overdue(): static
    {
        return $this->state(fn (array $attributes) => [
            'due_date' => $this->faker->dateTimeBetween('-2 months', '-1 day'),
            'status' => $this->faker->randomElement(['planned', 'approved', 'pending']),
        ]);
    }
}
