<?php

namespace Database\Factories;

use App\Models\User;
use App\Models\Personnel;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Personnel>
 */
class PersonnelFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = Personnel::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $hireDate = $this->faker->dateTimeBetween('-5 years', 'now');
        $birthDate = $this->faker->dateTimeBetween('-60 years', '-18 years');
        
        return [
            'first_name' => $this->faker->firstName(),
            'last_name' => $this->faker->lastName(),
            'email' => $this->faker->unique()->safeEmail(),
            'phone' => $this->faker->phoneNumber(),
            'position' => $this->faker->randomElement([
                'Développeur Full Stack', 'Chef de Projet', 'Analyste Business', 'Designer UX/UI',
                'DevOps Engineer', 'Data Scientist', 'Product Owner', 'Scrum Master',
                'Architecte Solution', 'Testeur QA', 'Chef d\'équipe', 'Directeur Technique'
            ]),
            'department' => $this->faker->randomElement([
                'Développement', 'Design', 'Produit', 'DevOps', 'Data', 'QA', 'Management'
            ]),
            'hire_date' => $hireDate,
            'salary' => $this->faker->randomFloat(2, 2500, 15000),
            'status' => $this->faker->randomElement(['active', 'inactive', 'on_leave', 'terminated']),
            'employee_id' => 'EMP' . $this->faker->unique()->numberBetween(1000, 9999),
            'manager_id' => null,
            'skills' => $this->faker->randomElements([
                'PHP', 'Laravel', 'JavaScript', 'Vue.js', 'React', 'Node.js', 'Python',
                'Java', 'C#', 'SQL', 'MongoDB', 'Redis', 'Docker', 'Kubernetes',
                'AWS', 'Azure', 'Git', 'CI/CD', 'Agile', 'Scrum', 'Design Patterns'
            ], rand(3, 8)),
            'certifications' => $this->faker->optional()->randomElements([
                'AWS Certified Developer', 'Microsoft Certified: Azure Developer',
                'Certified Scrum Master', 'PMP', 'ITIL Foundation', 'Google Cloud Professional'
            ], rand(0, 3)),
            'languages' => $this->faker->randomElements([
                'Français', 'Anglais', 'Espagnol', 'Allemand', 'Italien', 'Chinois'
            ], rand(1, 3)),
            'emergency_contact' => [
                'name' => $this->faker->name(),
                'phone' => $this->faker->phoneNumber(),
                'relationship' => $this->faker->randomElement(['Conjoint', 'Parent', 'Frère/Sœur', 'Ami'])
            ],
            'address' => $this->faker->streetAddress(),
            'city' => $this->faker->city(),
            'postal_code' => $this->faker->postcode(),
            'country' => $this->faker->country(),
            'date_of_birth' => $birthDate,
            'gender' => $this->faker->randomElement(['male', 'female', 'other', 'prefer_not_to_say']),
            'marital_status' => $this->faker->randomElement(['single', 'married', 'divorced', 'widowed']),
            'nationality' => $this->faker->country(),
            'passport_number' => $this->faker->optional()->regexify('[A-Z]{2}[0-9]{7}'),
            'tax_id' => $this->faker->optional()->regexify('[0-9]{10}'),
            'bank_account' => $this->faker->optional()->regexify('FR[0-9]{10}[A-Z0-9]{11}[0-9]{2}'),
            'contract_type' => $this->faker->randomElement(['full_time', 'part_time', 'contract', 'intern', 'temporary']),
            'work_schedule' => $this->faker->randomElement(['9h-18h', '8h-17h', 'Flexible', 'Remote']),
            'overtime_eligible' => $this->faker->boolean(70),
            'remote_work_allowed' => $this->faker->boolean(80),
            'probation_period' => $this->faker->optional()->numberBetween(30, 180),
            'performance_rating' => $this->faker->optional()->randomFloat(1, 3.0, 5.0),
            'notes' => $this->faker->optional()->paragraph(),
            'avatar' => $this->faker->optional()->imageUrl(200, 200, 'people'),
            'documents' => $this->faker->optional()->randomElements([
                'cv.pdf', 'contrat.pdf', 'attestation.pdf', 'diplome.pdf'
            ], rand(0, 3)),
            'created_by' => User::factory(),
            'created_at' => $this->faker->dateTimeBetween('-1 year', 'now'),
            'updated_at' => function (array $attributes) {
                return $this->faker->dateTimeBetween($attributes['created_at'], 'now');
            },
        ];
    }

    /**
     * Indicate that the personnel is active.
     */
    public function active(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'active',
            'hire_date' => $this->faker->dateTimeBetween('-3 years', '-6 months'),
        ]);
    }

    /**
     * Indicate that the personnel is a manager.
     */
    public function manager(): static
    {
        return $this->state(fn (array $attributes) => [
            'position' => $this->faker->randomElement([
                'Chef de Projet', 'Directeur Technique', 'Chef d\'équipe', 'Product Owner'
            ]),
            'salary' => $this->faker->randomFloat(2, 8000, 20000),
            'performance_rating' => $this->faker->randomFloat(1, 4.0, 5.0),
        ]);
    }

    /**
     * Indicate that the personnel is a developer.
     */
    public function developer(): static
    {
        return $this->state(fn (array $attributes) => [
            'position' => $this->faker->randomElement([
                'Développeur Full Stack', 'Développeur Frontend', 'Développeur Backend',
                'DevOps Engineer', 'Data Scientist'
            ]),
            'department' => 'Développement',
            'skills' => $this->faker->randomElements([
                'PHP', 'Laravel', 'JavaScript', 'Vue.js', 'React', 'Node.js', 'Python',
                'Java', 'C#', 'SQL', 'MongoDB', 'Redis', 'Docker', 'Kubernetes'
            ], rand(5, 10)),
        ]);
    }

    /**
     * Indicate that the personnel is on leave.
     */
    public function onLeave(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'on_leave',
            'hire_date' => $this->faker->dateTimeBetween('-2 years', '-1 year'),
        ]);
    }

    /**
     * Indicate that the personnel is terminated.
     */
    public function terminated(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'terminated',
            'hire_date' => $this->faker->dateTimeBetween('-3 years', '-1 year'),
        ]);
    }

    /**
     * Indicate that the personnel is a contractor.
     */
    public function contractor(): static
    {
        return $this->state(fn (array $attributes) => [
            'contract_type' => 'contract',
            'salary' => $this->faker->randomFloat(2, 400, 800), // Taux journalier
            'work_schedule' => 'Flexible',
            'overtime_eligible' => false,
        ]);
    }

    /**
     * Indicate that the personnel is an intern.
     */
    public function intern(): static
    {
        return $this->state(fn (array $attributes) => [
            'contract_type' => 'intern',
            'salary' => $this->faker->randomFloat(2, 800, 1500),
            'hire_date' => $this->faker->dateTimeBetween('-6 months', 'now'),
            'probation_period' => null,
        ]);
    }
}
