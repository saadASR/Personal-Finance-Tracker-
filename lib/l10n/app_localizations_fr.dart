// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Suivi des Finances';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get transactions => 'Transactions';

  @override
  String get categories => 'Catégories';

  @override
  String get budgets => 'Budgets';

  @override
  String get settings => 'Paramètres';

  @override
  String get income => 'Revenus';

  @override
  String get expenses => 'Dépenses';

  @override
  String get balance => 'Solde';

  @override
  String get balanceTrend => 'Tendance du solde';

  @override
  String get spendingByCategory => 'Dépenses par catégorie';

  @override
  String get recentTransactions => 'Transactions récentes';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get addTransaction => 'Ajouter une transaction';

  @override
  String get editTransaction => 'Modifier la transaction';

  @override
  String get title => 'Titre';

  @override
  String get amount => 'Montant';

  @override
  String get category => 'Catégorie';

  @override
  String get date => 'Date';

  @override
  String get note => 'Note';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get noTransactions => 'Aucune transaction';

  @override
  String get addCategory => 'Ajouter une catégorie';

  @override
  String get editCategory => 'Modifier la catégorie';

  @override
  String get categoryName => 'Nom de la catégorie';

  @override
  String get icon => 'Icône';

  @override
  String get color => 'Couleur';

  @override
  String get preview => 'Aperçu';

  @override
  String get noCategories => 'Aucune catégorie';

  @override
  String get defaultCategory => 'Catégorie par défaut';

  @override
  String get cannotDeleteCategory =>
      'Impossible de supprimer la catégorie en cours d\'utilisation';

  @override
  String get addBudget => 'Ajouter un budget';

  @override
  String get editBudget => 'Modifier le budget';

  @override
  String get budgetLimit => 'Limite du budget';

  @override
  String get alertSettings => 'Paramètres d\'alerte';

  @override
  String get noBudgets => 'Aucun budget défini';

  @override
  String get remaining => 'restant';

  @override
  String get overBudget => 'dépassement';

  @override
  String get used => 'utilisé';

  @override
  String get appearance => 'Apparence';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get currency => 'Devise';

  @override
  String get language => 'Langue';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get builtWithFlutter => 'Créé avec Flutter';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get budgetAlerts => 'Alertes de budget';

  @override
  String get noBudgetAlerts => 'Aucune alerte de budget';

  @override
  String alertWhen(int percent) {
    return 'Alerter à $percent% du budget utilisé';
  }

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get arabic => 'Arabe';
}
