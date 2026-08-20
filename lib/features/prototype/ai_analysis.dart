class AiAnalyzedProduct {
  const AiAnalyzedProduct({
    required this.name,
    required this.category,
    required this.description,
    required this.score,
    required this.ingredients,
  });

  factory AiAnalyzedProduct.fromJson(Map<String, dynamic> json) =>
      AiAnalyzedProduct(
        name: json['name'] as String? ?? '촬영 제품',
        category: json['category'] as String? ?? '스킨케어',
        description: json['description'] as String? ?? 'AI 분석 제품',
        score: (json['individual_score'] as num?)?.toInt() ?? 0,
        ingredients: (json['ingredients'] as List<dynamic>? ?? const [])
            .map((item) => item.toString())
            .toList(growable: false),
      );

  final String name;
  final String category;
  final String description;
  final int score;
  final List<String> ingredients;
}

class AiRemoveCandidate {
  const AiRemoveCandidate({
    required this.product,
    required this.reason,
    required this.scoreAfterRemoval,
  });

  factory AiRemoveCandidate.fromJson(Map<String, dynamic> json) =>
      AiRemoveCandidate(
        product: json['product'] as String? ?? '분석 제품',
        reason: json['reason'] as String? ?? '루틴 중복 성분을 줄이는 것을 권장합니다.',
        scoreAfterRemoval: (json['score_after_removal'] as num?)?.toInt() ?? 0,
      );

  final String product;
  final String reason;
  final int scoreAfterRemoval;
}

class AiRoutineAnalysis {
  const AiRoutineAnalysis({
    required this.products,
    required this.overallScore,
    required this.summary,
    required this.removeCandidates,
  });

  factory AiRoutineAnalysis.fromJson(Map<String, dynamic> json) =>
      AiRoutineAnalysis(
        products: (json['products'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(AiAnalyzedProduct.fromJson)
            .toList(growable: false),
        overallScore: (json['overall_score'] as num?)?.toInt() ?? 0,
        summary: json['summary'] as String? ?? 'AI 루틴 분석이 완료되었습니다.',
        removeCandidates:
            (json['remove_candidates'] as List<dynamic>? ?? const [])
                .whereType<Map<String, dynamic>>()
                .map(AiRemoveCandidate.fromJson)
                .toList(growable: false),
      );

  final List<AiAnalyzedProduct> products;
  final int overallScore;
  final String summary;
  final List<AiRemoveCandidate> removeCandidates;
}
