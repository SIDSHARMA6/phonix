# Design Document

## Overview

The Flutter web quiz application will be a single-page application (SPA) that presents medical questionnaires in a clean, responsive interface. The application follows a card-based design pattern with a prominent header and centered content area that adapts seamlessly across all device sizes.

The core architecture will use Flutter's built-in state management with StatefulWidget to handle question navigation and answer selection. The design prioritizes simplicity, accessibility, and visual consistency with the Phoenix brand identity.

## Architecture

### Application Structure
```
lib/
├── main.dart                 # App entry point and theme configuration
├── models/
│   ├── question.dart         # Question data model
│   └── quiz_data.dart        # Static quiz questions data
├── screens/
│   └── quiz_screen.dart      # Main quiz interface
├── widgets/
│   ├── quiz_header.dart      # Phoenix branded header
│   ├── question_card.dart    # Question display component
│   ├── answer_option.dart    # Individual answer option
│   └── navigation_buttons.dart # Previous/Next buttons
└── utils/
    └── responsive_helper.dart # Screen size utilities
```

### State Management
- **Local State**: StatefulWidget for quiz progression, current question index, and selected answers
- **Question Data**: Static list of Question objects loaded at app initialization
- **Navigation State**: Simple integer-based indexing for question progression

### Responsive Design Strategy
- **Breakpoints**: 
  - Mobile: < 600px width
  - Tablet: 600px - 1024px width  
  - Desktop: > 1024px width
- **Layout Adaptation**: Single-column layout with responsive padding and font scaling
- **Touch Targets**: Minimum 48px height for answer options on mobile

## Components and Interfaces

### Question Model
```dart
class Question {
  final String id;
  final String text;
  final List<String> options;
  
  Question({
    required this.id,
    required this.text,
    required this.options,
  });
}
```

### Quiz Screen Interface
- **State Properties**:
  - `currentQuestionIndex`: int (0-based indexing)
  - `selectedAnswers`: Map<int, int> (question index -> selected option index)
  - `questions`: List<Question> (static data)

- **Key Methods**:
  - `selectAnswer(int optionIndex)`: Records answer and auto-advances
  - `goToPrevious()`: Navigates to previous question
  - `goToNext()`: Navigates to next question (if answer selected)

### UI Components

#### QuizHeader Widget
- Fixed height header (80px on desktop, 60px on mobile)
- Dark blue background (#1a237e)
- Centered "PHOENIX" text in white
- Responsive typography scaling

#### QuestionCard Widget
- Centered card layout with subtle shadow
- Maximum width constraints (800px desktop, full-width mobile)
- Question text with responsive typography
- Vertical spacing between question and options

#### AnswerOption Widget
- Card-based design with hover states
- Minimum touch target size (48px height)
- Selected state visual feedback
- Smooth transitions for interactions

#### NavigationButtons Widget
- Previous/Next button layout
- Conditional rendering based on question position
- Disabled states for invalid navigation
- Responsive button sizing

## Data Models

### Question Structure
Each question contains:
- **id**: Unique identifier for tracking
- **text**: The question content
- **options**: Array of 3-5 answer choices

### Quiz Data Organization
```dart
class QuizData {
  static final List<Question> questions = [
    Question(
      id: 'q1',
      text: 'How did your ED begin? Select the one that best describes your ED.',
      options: [
        'Gradually but has worsened over time',
        'Suddenly, but not with a new partner',
        'Suddenly, with a new partner',
        'I do not recall how it began'
      ],
    ),
    // Additional 19-29 questions...
  ];
}
```

### Answer Storage
- Simple Map<int, int> structure
- Key: Question index (0-based)
- Value: Selected option index (0-based)
- Persisted in widget state only (no local storage required)

## Error Handling

### Navigation Errors
- **Invalid Question Index**: Clamp to valid range (0 to questions.length-1)
- **Missing Answer Selection**: Disable next navigation until answer selected
- **Boundary Conditions**: Hide previous button on first question, handle last question completion

### Data Validation
- **Question Loading**: Validate questions list is not empty on app start
- **Option Selection**: Ensure selected index is within valid range
- **State Consistency**: Validate currentQuestionIndex matches available questions

### User Experience Errors
- **Rapid Clicking**: Debounce answer selection to prevent double-selection
- **Browser Back Button**: Handle browser navigation gracefully
- **Screen Rotation**: Maintain state during orientation changes

## Testing Strategy

### Unit Tests
- **Question Model**: Validate question creation and properties
- **Quiz Data**: Ensure all questions have valid structure
- **Navigation Logic**: Test question progression and boundary conditions
- **Answer Selection**: Verify answer storage and retrieval

### Widget Tests
- **QuizScreen**: Test question display and navigation
- **AnswerOption**: Verify selection states and callbacks
- **NavigationButtons**: Test button visibility and functionality
- **Responsive Layout**: Test layout adaptation across screen sizes

### Integration Tests
- **Complete Quiz Flow**: Navigate through all questions
- **Answer Persistence**: Verify answers are maintained during navigation
- **Responsive Behavior**: Test on different screen sizes
- **Browser Compatibility**: Test on major web browsers

### Manual Testing Checklist
- [ ] Visual design matches provided mockup
- [ ] Smooth transitions between questions
- [ ] Proper responsive behavior on all devices
- [ ] Accessibility compliance (keyboard navigation, screen readers)
- [ ] Performance on slower devices/connections

## Performance Considerations

### Web Optimization
- **Bundle Size**: Minimize dependencies, use tree-shaking
- **Loading Speed**: Optimize initial bundle size for fast first load
- **Runtime Performance**: Efficient widget rebuilds, minimal state changes

### Responsive Performance
- **Layout Calculations**: Cache responsive breakpoint calculations
- **Image Assets**: Use appropriate image sizes for different screen densities
- **Animation Performance**: Use Flutter's optimized animation widgets

### Memory Management
- **Static Data**: Questions loaded once at startup
- **Widget Lifecycle**: Proper disposal of controllers and listeners
- **State Efficiency**: Minimal state updates, efficient data structures