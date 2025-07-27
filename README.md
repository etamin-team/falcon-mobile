# 📱 Falcon Mobile

**Falcon Mobile** — это кроссплатформенное мобильное приложение, разработанное командой Etamin Team. Приложение предоставляет пользователям быстрый и удобный способ управления заказами, отслеживания данных в реальном времени и других ключевых функций.

---

## 🚀 Используемые технологии

* **Flutter** – разработка кроссплатформенных мобильных приложений
* **Dart** – основной язык программирования
* **BLoC / Cubit** – управление состояниями приложения
* **REST API** – взаимодействие с серверной частью
* **Firebase** – если используется: авторизация, уведомления, аналитика
* **Google Maps API** – интеграция карты
* **Secure Storage / Local DB** – локальное хранение данных (Hive, SQLite и др.)

---

## 📁 Структура проекта

```
falcon-mobile/
├── lib/
│   ├── main.dart
│   ├── src/
│   │   ├── features/
│   │   ├── models/
│   │   ├── services/
│   │   ├── widgets/
│   │   └── utils/
├── assets/
│   ├── images/
│   └── icons/
├── pubspec.yaml
└── README.md
```

---

## ⚙️ Установка и запуск

### 🛠 Требования:

* Flutter SDK (>=3.x)
* Android Studio или VS Code
* Эмулятор или физическое устройство

### 🚀 Шаги по установке:

```bash
# 1. Клонировать репозиторий
git clone https://github.com/etamin-team/falcon-mobile.git

# 2. Перейти в папку проекта
cd falcon-mobile

# 3. Установить зависимости
flutter pub get

# 4. Запустить приложение
flutter run
```

> ⚠️ Если используется Firebase, убедитесь, что `google-services.json` и `GoogleService-Info.plist` добавлены.

---

## 📅 Тестирование

```bash
flutter test
```

Юнит- и виджет-тесты находятся в папке `test/`.

---

## 📸 Скриншоты

| Главная                               | Профиль                               | Карта                                 |
| ------------------------------------- | ------------------------------------- | ------------------------------------- |
| ![screen1](assets/images/screen1.png) | ![screen2](assets/images/screen2.png) | ![screen3](assets/images/screen3.png) |

---

## 📜 Лицензия

Проект лицензирован под лицензией MIT. Подробнее в файле [`LICENSE`](LICENSE).

---

## 👨‍💼 Авторы

* [Etamin Team](https://github.com/etamin-team)

📅 Приглашаем к сотрудничеству! Создайте `fork`, реализуйте новую функциональность и отправьте Pull Request.

---

## 📬 Контакты

* Telegram: [@etaminteam](https://t.me/etaminteam)
* Email: [info@etamin.uz](mailto:info@etamin.uz)
* Сайт: [etamin.uz](https://etamin.uz)

---

**Falcon Mobile** — это безопасный, производительный и современный инструмент для мобильного взаимодействия с данными и сервисами.
