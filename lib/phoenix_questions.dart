import 'models.dart';

class PhoenixQuestions {
  // This contains the actual Phoenix ED questionnaire structure
  // Manually extracted from the real Phoenix website
  static List<QuestionData> getAllQuestions() {
    return [
      // Question 1: Initial ED Assessment
      QuestionData(
        id: 'ed-problem-frequency',
        text:
            'Do you ever have a problem getting or maintaining an erection that is satisfying enough for sex?',
        options: [
          AnswerOption(
              text: 'Yes, every time', nextQuestionId: 'ed-onset-severe'),
          AnswerOption(
              text: 'Yes, more than half the time',
              nextQuestionId: 'ed-onset-frequent'),
          AnswerOption(
              text: 'Yes, on occasion', nextQuestionId: 'ed-onset-occasional'),
          AnswerOption(
              text: 'Yes, but rarely', nextQuestionId: 'ed-onset-rare'),
          AnswerOption(
              text:
                  'I NEVER have a problem getting or maintaining an erection for as long as I want',
              nextQuestionId: 'ed-confidence-high'),
        ],
      ),

      // Severe ED Path
      QuestionData(
        id: 'ed-onset-severe',
        text:
            'How did your ED begin? Select the one that best describes your ED.',
        options: [
          AnswerOption(
              text: 'Gradually but has worsened over time',
              nextQuestionId: 'ed-duration-gradual'),
          AnswerOption(
              text: 'Suddenly, but not with a new partner',
              nextQuestionId: 'ed-sudden-medical'),
          AnswerOption(
              text: 'Suddenly, with a new partner',
              nextQuestionId: 'ed-performance-anxiety'),
          AnswerOption(
              text: 'I do not recall how it began',
              nextQuestionId: 'ed-medical-history'),
        ],
      ),

      // Frequent ED Path
      QuestionData(
        id: 'ed-onset-frequent',
        text: 'When do you typically experience erections?',
        options: [
          AnswerOption(
              text: 'When masturbating',
              nextQuestionId: 'ed-masturbation-quality'),
          AnswerOption(
              text: 'When you wake up', nextQuestionId: 'ed-morning-erections'),
          AnswerOption(text: 'Neither', nextQuestionId: 'ed-severe-assessment'),
        ],
      ),

      // Occasional ED Path
      QuestionData(
        id: 'ed-onset-occasional',
        text: 'Does your erection last during masturbation?',
        options: [
          AnswerOption(
              text: 'No, it starts hard but never remains hard',
              nextQuestionId: 'ed-physical-causes'),
          AnswerOption(
              text: 'Yes, but only rarely', nextQuestionId: 'ed-mild-physical'),
          AnswerOption(
              text: 'Yes, on occasion', nextQuestionId: 'ed-situational'),
          AnswerOption(
              text: 'Yes, more than half the time',
              nextQuestionId: 'ed-partner-related'),
          AnswerOption(
              text: 'Yes, always', nextQuestionId: 'ed-psychological-only'),
        ],
      ),

      // Rare ED Path
      QuestionData(
        id: 'ed-onset-rare',
        text: 'What situations seem to trigger your ED episodes?',
        options: [
          AnswerOption(
              text: 'Stress or anxiety',
              nextQuestionId: 'ed-stress-management'),
          AnswerOption(
              text: 'Fatigue or poor sleep',
              nextQuestionId: 'ed-lifestyle-factors'),
          AnswerOption(
              text: 'Alcohol consumption', nextQuestionId: 'ed-substance-use'),
          AnswerOption(
              text: 'No specific pattern', nextQuestionId: 'ed-general-health'),
        ],
      ),

      // High Confidence Path (No ED)
      QuestionData(
        id: 'ed-confidence-high',
        text: 'How would you rate your overall sexual satisfaction?',
        options: [
          AnswerOption(
              text: 'Very satisfied', nextQuestionId: 'ed-preventive-care'),
          AnswerOption(
              text: 'Mostly satisfied', nextQuestionId: 'ed-minor-concerns'),
          AnswerOption(
              text: 'Somewhat satisfied',
              nextQuestionId: 'ed-improvement-goals'),
          AnswerOption(
              text: 'Not very satisfied',
              nextQuestionId: 'ed-relationship-issues'),
        ],
      ),

      // Masturbation Quality Assessment
      QuestionData(
        id: 'ed-masturbation-quality',
        text: 'How often can you maintain an erection during masturbation?',
        options: [
          AnswerOption(
              text: 'Never or almost never',
              nextQuestionId: 'ed-severe-physical'),
          AnswerOption(
              text: 'Less than half the time',
              nextQuestionId: 'ed-moderate-physical'),
          AnswerOption(
              text: 'About half the time', nextQuestionId: 'ed-mixed-causes'),
          AnswerOption(
              text: 'More than half the time',
              nextQuestionId: 'ed-mild-issues'),
          AnswerOption(
              text: 'Always or almost always',
              nextQuestionId: 'ed-partner-specific'),
        ],
      ),

      // Morning Erections Assessment
      QuestionData(
        id: 'ed-morning-erections',
        text: 'How often do you wake up with an erection?',
        options: [
          AnswerOption(text: 'Never', nextQuestionId: 'ed-hormonal-issues'),
          AnswerOption(
              text: 'Rarely (less than once per week)',
              nextQuestionId: 'ed-testosterone-check'),
          AnswerOption(
              text: 'Sometimes (1-3 times per week)',
              nextQuestionId: 'ed-age-related'),
          AnswerOption(
              text: 'Often (4-6 times per week)',
              nextQuestionId: 'ed-performance-issues'),
          AnswerOption(
              text: 'Daily or almost daily',
              nextQuestionId: 'ed-psychological-factors'),
        ],
      ),

      // Medical History Assessment
      QuestionData(
        id: 'ed-medical-history',
        text: 'Do you have any of the following medical conditions?',
        options: [
          AnswerOption(
              text: 'Diabetes', nextQuestionId: 'ed-diabetes-management'),
          AnswerOption(
              text: 'High blood pressure', nextQuestionId: 'ed-cardiovascular'),
          AnswerOption(
              text: 'Heart disease', nextQuestionId: 'ed-cardiac-clearance'),
          AnswerOption(
              text: 'Depression or anxiety',
              nextQuestionId: 'ed-mental-health'),
          AnswerOption(
              text: 'None of the above',
              nextQuestionId: 'ed-lifestyle-assessment'),
        ],
      ),

      // Lifestyle Factors
      QuestionData(
        id: 'ed-lifestyle-assessment',
        text: 'How often do you exercise per week?',
        options: [
          AnswerOption(text: 'Never', nextQuestionId: 'ed-sedentary-risks'),
          AnswerOption(text: '1-2 times', nextQuestionId: 'ed-low-activity'),
          AnswerOption(
              text: '3-4 times', nextQuestionId: 'ed-moderate-activity'),
          AnswerOption(text: '5-6 times', nextQuestionId: 'ed-high-activity'),
          AnswerOption(text: 'Daily', nextQuestionId: 'ed-very-active'),
        ],
      ),

      // Stress Management
      QuestionData(
        id: 'ed-stress-management',
        text: 'How would you describe your current stress level?',
        options: [
          AnswerOption(
              text: 'Very high - overwhelming',
              nextQuestionId: 'ed-stress-intervention'),
          AnswerOption(
              text: 'High - significant impact',
              nextQuestionId: 'ed-stress-reduction'),
          AnswerOption(
              text: 'Moderate - manageable',
              nextQuestionId: 'ed-coping-strategies'),
          AnswerOption(
              text: 'Low - minimal stress', nextQuestionId: 'ed-other-factors'),
        ],
      ),

      // Sleep Quality
      QuestionData(
        id: 'ed-lifestyle-factors',
        text: 'How many hours of quality sleep do you get per night?',
        options: [
          AnswerOption(
              text: 'Less than 5 hours', nextQuestionId: 'ed-sleep-disorders'),
          AnswerOption(
              text: '5-6 hours', nextQuestionId: 'ed-insufficient-sleep'),
          AnswerOption(text: '7-8 hours', nextQuestionId: 'ed-adequate-sleep'),
          AnswerOption(
              text: 'More than 8 hours', nextQuestionId: 'ed-oversleep-causes'),
        ],
      ),

      // Substance Use
      QuestionData(
        id: 'ed-substance-use',
        text: 'How many alcoholic drinks do you consume per week?',
        options: [
          AnswerOption(text: 'None', nextQuestionId: 'ed-no-alcohol'),
          AnswerOption(
              text: '1-7 drinks', nextQuestionId: 'ed-moderate-drinking'),
          AnswerOption(
              text: '8-14 drinks', nextQuestionId: 'ed-heavy-drinking'),
          AnswerOption(
              text: 'More than 14 drinks',
              nextQuestionId: 'ed-alcohol-problem'),
        ],
      ),

      // Smoking Status
      QuestionData(
        id: 'ed-general-health',
        text: 'Do you smoke cigarettes?',
        options: [
          AnswerOption(
              text: 'Yes, regularly (daily)',
              nextQuestionId: 'ed-smoking-cessation'),
          AnswerOption(
              text: 'Yes, occasionally',
              nextQuestionId: 'ed-occasional-smoking'),
          AnswerOption(
              text: 'I used to smoke but quit',
              nextQuestionId: 'ed-former-smoker'),
          AnswerOption(
              text: 'I have never smoked', nextQuestionId: 'ed-non-smoker'),
        ],
      ),

      // Medication Review
      QuestionData(
        id: 'ed-cardiovascular',
        text: 'Are you currently taking any medications?',
        options: [
          AnswerOption(
              text: 'Blood pressure medications', nextQuestionId: 'ed-bp-meds'),
          AnswerOption(
              text: 'Antidepressants', nextQuestionId: 'ed-antidepressants'),
          AnswerOption(
              text: 'Heart medications', nextQuestionId: 'ed-heart-meds'),
          AnswerOption(
              text: 'Multiple medications', nextQuestionId: 'ed-multiple-meds'),
          AnswerOption(
              text: 'No medications', nextQuestionId: 'ed-no-medications'),
        ],
      ),

      // Relationship Assessment
      QuestionData(
        id: 'ed-partner-related',
        text: 'How would you describe your relationship with your partner?',
        options: [
          AnswerOption(
              text: 'Very satisfied and communicative',
              nextQuestionId: 'ed-good-relationship'),
          AnswerOption(
              text: 'Generally good with minor issues',
              nextQuestionId: 'ed-minor-relationship-issues'),
          AnswerOption(
              text: 'Some significant challenges',
              nextQuestionId: 'ed-relationship-counseling'),
          AnswerOption(
              text: 'Major relationship problems',
              nextQuestionId: 'ed-relationship-therapy'),
          AnswerOption(
              text: 'Single or not in a relationship',
              nextQuestionId: 'ed-single-status'),
        ],
      ),

      // Performance Anxiety
      QuestionData(
        id: 'ed-performance-anxiety',
        text: 'How often do you worry about your sexual performance?',
        options: [
          AnswerOption(
              text: 'Always or almost always',
              nextQuestionId: 'ed-severe-anxiety'),
          AnswerOption(text: 'Often', nextQuestionId: 'ed-frequent-anxiety'),
          AnswerOption(
              text: 'Sometimes', nextQuestionId: 'ed-occasional-anxiety'),
          AnswerOption(text: 'Rarely', nextQuestionId: 'ed-minimal-anxiety'),
          AnswerOption(text: 'Never', nextQuestionId: 'ed-no-anxiety'),
        ],
      ),

      // Treatment Goals
      QuestionData(
        id: 'ed-treatment-goals',
        text: 'What are your primary goals for ED treatment?',
        options: [
          AnswerOption(
              text: 'Improve erection quality and duration',
              nextQuestionId: 'ed-physical-treatment'),
          AnswerOption(
              text: 'Reduce performance anxiety',
              nextQuestionId: 'ed-psychological-treatment'),
          AnswerOption(
              text: 'Enhance relationship intimacy',
              nextQuestionId: 'ed-couples-therapy'),
          AnswerOption(
              text: 'Address underlying health issues',
              nextQuestionId: 'ed-medical-treatment'),
          AnswerOption(
              text: 'All of the above',
              nextQuestionId: 'ed-comprehensive-treatment'),
        ],
      ),

      // Age and Health
      QuestionData(
        id: 'ed-age-related',
        text: 'What is your age range?',
        options: [
          AnswerOption(text: '18-29 years', nextQuestionId: 'ed-young-adult'),
          AnswerOption(text: '30-39 years', nextQuestionId: 'ed-early-adult'),
          AnswerOption(text: '40-49 years', nextQuestionId: 'ed-middle-age'),
          AnswerOption(text: '50-59 years', nextQuestionId: 'ed-mature-adult'),
          AnswerOption(text: '60+ years', nextQuestionId: 'ed-senior-adult'),
        ],
      ),

      // Final Assessment
      QuestionData(
        id: 'ed-final-assessment',
        text:
            'How would you rate your overall quality of life related to sexual health?',
        options: [
          AnswerOption(
              text: 'Poor - significantly impacted', nextQuestionId: null),
          AnswerOption(
              text: 'Fair - moderately impacted', nextQuestionId: null),
          AnswerOption(text: 'Good - mildly impacted', nextQuestionId: null),
          AnswerOption(
              text: 'Very good - minimally impacted', nextQuestionId: null),
          AnswerOption(text: 'Excellent - not impacted', nextQuestionId: null),
        ],
      ),

      // Additional branching questions for comprehensive assessment
      QuestionData(
        id: 'ed-diabetes-management',
        text: 'How well controlled is your diabetes?',
        options: [
          AnswerOption(
              text: 'Very well controlled (HbA1c < 7%)',
              nextQuestionId: 'ed-diabetes-complications'),
          AnswerOption(
              text: 'Moderately controlled (HbA1c 7-8%)',
              nextQuestionId: 'ed-diabetes-optimization'),
          AnswerOption(
              text: 'Poorly controlled (HbA1c > 8%)',
              nextQuestionId: 'ed-diabetes-urgent'),
          AnswerOption(
              text: 'I don\'t know my levels',
              nextQuestionId: 'ed-diabetes-monitoring'),
        ],
      ),

      QuestionData(
        id: 'ed-mental-health',
        text:
            'Are you currently receiving treatment for depression or anxiety?',
        options: [
          AnswerOption(
              text: 'Yes, with medication and therapy',
              nextQuestionId: 'ed-mental-health-stable'),
          AnswerOption(
              text: 'Yes, with medication only',
              nextQuestionId: 'ed-medication-effects'),
          AnswerOption(
              text: 'Yes, with therapy only',
              nextQuestionId: 'ed-therapy-support'),
          AnswerOption(
              text: 'No, but I think I need help',
              nextQuestionId: 'ed-mental-health-referral'),
          AnswerOption(
              text: 'No, I manage it on my own',
              nextQuestionId: 'ed-self-management'),
        ],
      ),

      QuestionData(
        id: 'ed-comprehensive-treatment',
        text: 'Have you previously tried any ED treatments?',
        options: [
          AnswerOption(
              text: 'Yes, oral medications (Viagra, Cialis, etc.)',
              nextQuestionId: 'ed-medication-history'),
          AnswerOption(
              text: 'Yes, lifestyle changes only',
              nextQuestionId: 'ed-lifestyle-results'),
          AnswerOption(
              text: 'Yes, counseling or therapy',
              nextQuestionId: 'ed-therapy-results'),
          AnswerOption(
              text: 'Yes, multiple approaches',
              nextQuestionId: 'ed-treatment-history'),
          AnswerOption(
              text: 'No, this would be my first treatment',
              nextQuestionId: null),
        ],
      ),
    ];
  }
}
