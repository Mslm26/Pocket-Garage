import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'account_details': 'Account Details',
      'profile_info': 'Profile Information',
      'full_name_hint': 'Full Name',
      'email_header': 'Email Address (Verification required for change)',
      'email_hint': 'Email',
      'password_header': 'New Password (Leave blank to keep current)',
      'password_hint': 'New Password',
      'save_changes': 'Save Changes',
      'terms_of_use': 'Terms of Use',
      'privacy_policy': 'Privacy Policy',
      'and': ' and ',
      'accept_terms': 'I accept the ',
      'accept_terms_suffix': '.',
      'terms_content': '''
1. Acceptance of Terms
By accessing or using the Pocket Garage application ("App"), you agree to be bound by these Terms of Use ("Terms"). If you do not agree to these Terms, you may not use the App.

2. User Accounts
To use certain features of the App, you may be required to create an account. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account. You agree to provide accurate and complete information when creating your account.

3. Use of the App
Pocket Garage is a vehicle management application designed to help users track vehicle expenses, maintenance schedules, and other related data. You agree to use the App only for lawful purposes and in accordance with these Terms.

4. User Content
You are solely responsible for the data, text, images, and other content ("User Content") that you upload or input into the App. You represent and warrant that you own or have the necessary rights to such User Content.

5. Intellectual Property
The App and its original content, features, and functionality are owned by Pocket Garage and are protected by international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.

6. Termination
We may terminate or suspend your access to the App immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.

7. Limitation of Liability
In no event shall Pocket Garage, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses.

8. Changes to Terms
We reserve the right, at our sole discretion, to modify or replace these Terms at any time. By continuing to access or use our App after those revisions become effective, you agree to be bound by the revised terms.
''',
      'privacy_content': '''
1. Introduction
Pocket Garage ("we," "our," or "us") respects your privacy and is committed to protecting your personal data. This Privacy Policy explains how we collect, use, and share information about you when you use our mobile application.

2. Information We Collect
- **Personal Information:** When you create an account, we may collect your name, email address, and password.
- **Vehicle Data:** We collect information about your vehicles, including make, model, year, license plate, inspection dates, and insurance dates.
- **Expense Data:** We collect data regarding your vehicle expenses, such as fuel, maintenance, and other costs, including dates and amounts.
- **Images:** If you choose to upload vehicle images, we store these images to display them within the App.

3. How We Use Your Information
We use the information we collect to:
- Provide, maintain, and improve the App.
- Process and track your vehicle expenses and maintenance schedules.
- Send you notifications regarding upcoming inspections or insurance renewals.
- Respond to your comments, questions, and customer service requests.

4. Data Storage and Security
We use Firebase services (Firestore and Cloud Storage) to store and secure your data. We implement reasonable security measures to protect your information from unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the Internet or electronic storage is 100% secure.

5. Sharing of Information
We do not share your personal information with third parties except as described in this policy or as required by law. We may share data with service providers who help us operate the App (e.g., cloud storage providers).

6. Your Rights
You have the right to access, correct, or delete your personal information stored in the App. You can delete your account and associated data through the App settings options.

7. Changes to This Policy
We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.
''',
      'email_verification_sent':
          'Verification email sent. Please confirm your new email.',
      'password_updated': 'Password updated.',
      'profile_updated': 'Profile information updated!',
      'relogin_required': 'For security reasons, you need to log in again.',
      'error_prefix': 'Error: ',
      'unknown_error': 'Unknown error: ',
      'welcome': 'Welcome',
      'settings': 'Settings',
      'add_first_vehicle': 'Press + button to add your first vehicle',
      'unnamed_vehicle': 'Unnamed Vehicle',
      'no_plate': 'No Plate',
      'edit_vehicle': 'Edit Vehicle',
      'add_new_vehicle': 'Add New Vehicle',
      'vehicle_name_label': 'Vehicle Name / Model',
      'vehicle_name_hint': 'Enter vehicle name or model',
      'model_year_label': 'Model Year',
      'model_year_hint': 'Enter model year',
      'plate_number_label': 'Plate Number',
      'plate_number_hint': 'Enter plate number',
      'inspection_date_label': 'Next Inspection Date',
      'insurance_date_label': 'Next Insurance Date',
      'fill_required_fields': 'Please fill in all required fields.',
      'invalid_year': 'Please enter a valid year (1900 - Next Year)',
      'invalid_plate':
          'Invalid plate format. (Use A-Z, 0-9, space and hyphen only)',
      'vehicle_updated': 'Vehicle updated!',
      'vehicle_added': 'Vehicle successfully added!',
      'pick_from_gallery': 'Pick from Gallery',
      'take_photo': 'Take Photo',
      'tap_to_add_image': 'Tap to add vehicle image',
      'save_vehicle': 'Save Vehicle',
      'error_occured': 'An error occurred',
      'vehicle_not_found': 'Vehicle not found',
      'next_inspection': 'Next Inspection',
      'next_insurance': 'Next Insurance',
      'not_set': 'Not Set',
      'expense_history': 'Expense History',
      'analysis': 'Analysis',
      'error_loading_expenses': 'Error loading expenses',
      'no_expenses_found':
          'No expense records found.\nAdd one by pressing + button.',
      'expense_fuel': 'Fuel',
      'expense_maintenance': 'Maintenance',
      'expense_wash': 'Wash',
      'expense_tires': 'Tires',
      'expense_other': 'Other',
      'edit': 'Edit',
      'delete': 'Delete',
      'delete_expense_title': 'Delete Expense',
      'delete_expense_confirm': 'Are you sure you want to delete this expense?',
      'expense_deleted': 'Expense deleted',
      'delete_vehicle_title': 'Delete Vehicle',
      'delete_vehicle_confirm':
          'Are you sure you want to delete this vehicle and all expense history? This action cannot be undone.',
      'expense_breakdown_title': 'Expense Breakdown',
      'period_weekly': 'Weekly',
      'period_monthly': 'Monthly',
      'period_6months': '6 Months',
      'period_yearly': 'Yearly',
      'total_expense': 'TOTAL EXPENSE',
      'top_category': 'Highest',
      'categories': 'Categories',
      'no_expenses_period': 'No expenses for this period.',
      'expense_insurance': 'Insurance',
      'expense_parts': 'Parts',
      'cancel': 'Cancel',
      'ok': 'OK',
      'add_expense_title': 'Add Expense',
      'edit_expense_title': 'Edit Expense',
      'amount_label': 'Amount',
      'title_label': 'Title',
      'save_expense': 'Save Expense',
      'enter_amount_error': 'Please enter an amount',
      'positive_amount_error': 'Amount must be greater than 0',
      'max_amount_error': 'Maximum amount is 1,000,000 ₺',
      'expense_saved': 'Expense saved!',
      'forgot_password_title': 'Forgot Password',
      'forgot_password_header': 'Reset Password',
      'forgot_password_desc':
          'Enter your email address and we will send you a link to reset your password.',
      'send_reset_link': 'Send Reset Link',
      'reset_email_sent':
          'Password reset email sent! Please check your inbox (and spam folder).',
      'invalid_email': 'Please enter a valid email address.',
      'user_not_found': 'No user found for this email.',
      'notification_inspection_title': 'Inspection Reminder',
      'notification_inspection_body':
          'Validation date for your vehicle {plate} has arrived!',
      'notification_insurance_title': 'Insurance Reminder',
      'notification_insurance_body':
          'Insurance date for your vehicle {plate} has arrived!',
    },
    'tr': {
      'account_details': 'Hesap Detayları',
      'profile_info': 'Profil Bilgileri',
      'full_name_hint': 'Adınız Soyadınız',
      'email_header': 'E-posta Adresi (Değişim için e-posta onayı gerekir)',
      'email_hint': 'E-posta',
      'password_header': 'Yeni Şifre (Değiştirmek istemiyorsanız boş bırakın)',
      'password_hint': 'Yeni Şifre',
      'save_changes': 'Değişiklikleri Kaydet',
      'terms_of_use': 'Kullanım Koşullarını',
      'privacy_policy': 'Gizlilik Politikasını',
      'and': ' ve ',
      'accept_terms': '',
      'accept_terms_suffix': ' kabul ediyorum',
      'terms_content': '''
1. Koşulların Kabulü
Pocket Garage uygulamasını ("Uygulama") kullanarak, bu Kullanım Koşullarına ("Koşullar") bağlı kalmayı kabul edersiniz. Bu Koşulları kabul etmiyorsanız, Uygulamayı kullanamazsınız.

2. Kullanıcı Hesapları
Uygulamanın belirli özelliklerini kullanmak için bir hesap oluşturmanız gerekebilir. Hesap bilgilerinizin gizliliğini korumaktan ve hesabınız altında gerçekleşen tüm etkinliklerden siz sorumlusunuz. Hesabınızı oluştururken doğru ve eksiksiz bilgi vermeyi kabul edersiniz.

3. Uygulamanın Kullanımı
Pocket Garage, kullanıcıların araç masraflarını, bakım programlarını ve diğer ilgili verileri takip etmelerine yardımcı olmak için tasarlanmış bir araç yönetim uygulamasıdır. Uygulamayı yalnızca yasal amaçlar için ve bu Koşullara uygun olarak kullanmayı kabul edersiniz.

4. Kullanıcı İçeriği
Uygulamaya yüklediğiniz veya girdiğiniz veriler, metinler, resimler ve diğer içeriklerden ("Kullanıcı İçeriği") yalnızca siz sorumlusunuz. Bu Kullanıcı İçeriğinin sahibi olduğunuzu veya gerekli haklara sahip olduğunuzu beyan ve taahhüt edersiniz.

5. Fikri Mülkiyet
Uygulama ve orijinal içeriği, özellikleri ve işlevselliği Pocket Garage'a aittir ve uluslararası telif hakkı, ticari marka, patent, ticari sır ve diğer fikri mülkiyet veya mülkiyet hakları yasalarıyla korunmaktadır.

6. Fesih
Koşulları ihlal etmeniz dahil ancak bunlarla sınırlı olmamak üzere, herhangi bir nedenle önceden bildirimde bulunmaksızın veya yükümlülük altına girmeksizin Uygulamaya erişiminizi derhal sonlandırabilir veya askıya alabiliriz.

7. Sorumluluk Sınırlaması
Pocket Garage, yöneticileri, çalışanları, ortakları, acenteleri, tedarikçileri veya iştirakleri, kar kaybı, veri kaybı, kullanım kaybı, şerefiye veya diğer maddi olmayan kayıplar dahil ancak bunlarla sınırlı olmamak üzere, hiçbir dolaylı, arızi, özel, sonuç olarak ortaya çıkan veya cezai zarardan sorumlu tutulamaz.

8. Koşullarda Değişiklikler
Tamamen kendi takdirimize bağlı olarak, bu Koşulları herhangi bir zamanda değiştirme veya yenileme hakkımızı saklı tutarız. Bu revizyonlar yürürlüğe girdikten sonra Uygulamamıza erişmeye veya kullanmaya devam ederek, revize edilen koşullara bağlı kalmayı kabul edersiniz.
''',
      'privacy_content': '''
1. Giriş
Pocket Garage ("biz" veya "bizim") gizliliğinize saygı duyar ve kişisel verilerinizi korumayı taahhüt eder. Bu Gizlilik Politikası, mobil uygulamamızı kullandığınızda hakkınızdaki bilgileri nasıl topladığımızı, kullandığımızı ve paylaştığımızı açıklar.

2. Topladığımız Bilgiler
- **Kişisel Bilgiler:** Bir hesap oluşturduğunuzda, adınızı, e-posta adresinizi ve şifrenizi toplayabiliriz.
- **Araç Verileri:** Araçlarınızın markası, modeli, yılı, plakası, muayene tarihleri ve sigorta tarihleri hakkında bilgi toplarız.
- **Masraf Verileri:** Yakıt, bakım ve diğer maliyetler dahil olmak üzere araç masraflarınıza ilişkin verileri (tarihler ve tutarlar dahil) toplarız.
- **Resimler:** Araç resimleri yüklemeyi seçerseniz, bunları Uygulama içinde görüntülemek için saklarız.

3. Bilgilerinizi Nasıl Kullanıyoruz
Topladığımız bilgileri şu amaçlarla kullanırız:
- Uygulamayı sağlamak, sürdürmek ve geliştirmek.
- Araç masraflarınızı ve bakım programlarınızı işlemek ve takip etmek.
- Yaklaşan muayene veya sigorta yenilemeleriyle ilgili bildirimler göndermek.
- Yorumlarınıza, sorularınıza ve müşteri hizmetleri taleplerinize yanıt vermek.

4. Veri Depolama ve Güvenlik
Verilerinizi saklamak ve güvence altına almak için Firebase hizmetlerini (Firestore ve Cloud Storage) kullanıyoruz. Bilgilerinizi yetkisiz erişim, değişiklik, ifşa veya imhadan korumak için makul güvenlik önlemleri uyguluyoruz. Ancak, İnternet üzerinden iletim veya elektronik depolama yöntemlerinin hiçbiri %100 güvenli değildir.

5. Bilgilerin Paylaşımı
Kişisel bilgilerinizi, bu politikada açıklanan durumlar veya yasaların gerektirdiği durumlar dışında üçüncü taraflarla paylaşmayız. Verileri, Uygulamayı işletmemize yardımcı olan hizmet sağlayıcılarla (ör. bulut depolama sağlayıcıları) paylaşabiliriz.

6. Haklarınız
Uygulamada saklanan kişisel bilgilerinize erişme, bunları düzeltme veya silme hakkına sahipsiniz. Hesabınızı ve ilgili verileri Uygulama ayarları seçeneklerinden silebilirsiniz.

7. Bu Politikadaki Değişiklikler
Gizlilik Politikamızı zaman zaman güncelleyebiliriz. Yeni Gizlilik Politikasını bu sayfada yayınlayarak sizi herhangi bir değişiklikten haberdar edeceğiz.
''',
      'email_verification_sent':
          'Doğrulama e-postası gönderildi. Lütfen yeni e-postanızı onaylayın.',
      'password_updated': 'Şifreniz güncellendi.',
      'profile_updated': 'Profil bilgileri güncellendi!',
      'relogin_required':
          'Güvenlik nedeniyle bu işlem için tekrar giriş yapmanız gerekiyor.',
      'error_prefix': 'Hata: ',
      'unknown_error': 'Bilinmeyen hata: ',
      'welcome': 'Hoşgeldin',
      'settings': 'Ayarlar',
      'add_first_vehicle': 'İlk aracınızı eklemek için + butonuna basın',
      'unnamed_vehicle': 'İsimsiz Araç',
      'no_plate': 'Plaka Yok',
      'edit_vehicle': 'Aracı Düzenle',
      'add_new_vehicle': 'Yeni Araç Ekle',
      'vehicle_name_label': 'Araç Adı / Modeli',
      'vehicle_name_hint': 'Araç adını veya modelini girin',
      'model_year_label': 'Model Yılı',
      'model_year_hint': 'Model yılını girin',
      'plate_number_label': 'Plaka Numarası',
      'plate_number_hint': 'Plaka numarasını girin',
      'inspection_date_label': 'Sonraki Muayene Tarihi',
      'insurance_date_label': 'Sonraki Sigorta Tarihi',
      'fill_required_fields': 'Lütfen tüm zorunlu alanları doldurun.',
      'invalid_year': 'Lütfen geçerli bir yıl giriniz (1900 - Gelecek Yıl)',
      'invalid_plate':
          'Plaka formatı geçersiz. (Yalnızca A-Z, 0-9, boşluk ve tire kullanın)',
      'vehicle_updated': 'Araç güncellendi!',
      'vehicle_added': 'Araç başarıyla eklendi!',
      'pick_from_gallery': 'Galeriden Seç',
      'take_photo': 'Kameradan Çek',
      'tap_to_add_image': 'Araç resmi eklemek için dokunun',
      'save_vehicle': 'Aracı Kaydet',
      'error_occured': 'Bir hata oluştu',
      'vehicle_not_found': 'Araç bulunamadı',
      'next_inspection': 'Sonraki Muayene',
      'next_insurance': 'Sonraki Sigorta',
      'not_set': 'Belirlenmedi',
      'expense_history': 'Masraf Geçmişi',
      'analysis': 'Analiz',
      'error_loading_expenses': 'Masraflar yüklenirken hata oluştu',
      'no_expenses_found':
          'Masraf kaydı bulunamadı.\n+ butonuna basarak ekleyin.',
      'expense_fuel': 'Yakıt',
      'expense_maintenance': 'Bakım',
      'expense_wash': 'Yıkama',
      'expense_tires': 'Lastik',
      'expense_other': 'Diğer',
      'edit': 'Düzenle',
      'delete': 'Sil',
      'delete_expense_title': 'Masrafı Sil',
      'delete_expense_confirm': 'Bu masrafı silmek istediğinize emin misiniz?',
      'expense_deleted': 'Masraf silindi',
      'delete_vehicle_title': 'Aracı Sil',
      'delete_vehicle_confirm':
          'Bu aracı ve tüm masraf geçmişini silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
      'expense_breakdown_title': 'Harcama Detayı',
      'period_weekly': 'Hafta',
      'period_monthly': 'Ay',
      'period_6months': '6 Ay',
      'period_yearly': 'Yıl',
      'total_expense': 'TOPLAM GİDER',
      'top_category': 'En Çok',
      'categories': 'Kategoriler',
      'no_expenses_period': 'Bu dönem için henüz harcama yok.',
      'expense_insurance': 'Sigorta',
      'expense_parts': 'Parça',
      'cancel': 'İptal',
      'ok': 'Tamam',
      'add_expense_title': 'Masraf Ekle',
      'edit_expense_title': 'Masrafı Düzenle',
      'amount_label': 'Tutar',
      'title_label': 'Başlık',
      'save_expense': 'Masrafı Kaydet',
      'enter_amount_error': 'Lütfen bir tutar giriniz',
      'positive_amount_error': 'Tutar 0\'dan büyük olmalıdır',
      'max_amount_error': 'Girilebilecek maksimum tutar 1.000.000 ₺ olabilir',
      'expense_saved': 'Masraf kaydedildi!',
      'forgot_password_title': 'Şifremi Unuttum',
      'forgot_password_header': 'Şifre Sıfırlama',
      'forgot_password_desc':
          'E-posta adresinizi girin, size şifrenizi sıfırlamanız için bir bağlantı gönderelim.',
      'send_reset_link': 'Sıfırlama Bağlantısı Gönder',
      'reset_email_sent':
          'Şifre sıfırlama e-postası gönderildi! Lütfen gelen kutunuzu (ve spam klasörünü) kontrol edin.',
      'invalid_email': 'Lütfen geçerli bir e-posta adresi giriniz.',
      'user_not_found': 'Bu e-posta ile kayıtlı kullanıcı bulunamadı.',
      'notification_inspection_title': 'Muayene Hatırlatması',
      'notification_inspection_body':
          '{plate} plakalı aracınızın muayene tarihi geldi!',
      'notification_insurance_title': 'Sigorta Hatırlatması',
      'notification_insurance_body':
          '{plate} plakalı aracınızın sigorta tarihi geldi!',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'tr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
