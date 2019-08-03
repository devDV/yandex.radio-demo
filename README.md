# yandex.radio-demo
Демо приложение с использованием публичного api radio.yandex.ru для демонстрации работы с JavaScript из WKWebView

1. radio.yandex.ru externalAPI.help() в JS консоли, 

файл externalAPI.swift и протоколы FlowSourceDelegate и FlowControl

2. класс RadioWKWebView:WKWebView - собственно радио

выполнение JS кода и разбор ответа для FlowControl evaluateJavaScript,
инъекция кода для подписки на события WKUserScript, получение ответов WKScriptMessageHandler,
отслеживание кликов пользователя по ссылкам WKUIDelegate, разбор шаблона делегирования

3. класс FlowController:FlowControl,FlowSourseDelegate  - управление источниками

разбор NotificationCenter

4. класс StatusBarController - иконка и меню в системном баре NSStatusBar

генерация меню
