

## День 1

Веб-серверы, rack-приложение, потоки/процессыю

Задание День 1

При выполнении задания все инструменты, скрипты и результаты надо фиксировать в репозитории.

1. Сделать небольшой план нагрузочного тестирования приложения на базе config.ru из репозитория day1/app на выбор:
  - приложения имеющего CPU-bound профиль нагрузки
  - приложения имеющего IO-bound профиль нагрузки
  - что-то еще?
2. Выполнить тестирование с использованием ab или siege (желающие могут попробовать Yandex Tank). При выполнении можно сфокусироваться на различных аспектах по своему усмотрению:
  - потребление памяти
  - нагрузка на CPU
  - параллелизм / емкость
  - длительность ответа / пропусканя способность (rps)
  - объём передаваемых данных mb/s
3. Сделать краткий отчёт с выводами в любой форме

### Практика (чеклист)

- rails сервер на Puma/Passenger/Thin/Falcon
- web-приложение:
  - sleep / threads / workers
  - Puma / Passenger / Thin
- Нагрузочное тестирование siege / ab
- Action Cable 
- Rack Hijack / throw :async

### Доп. материалы по теме

- [The Mythical IO-Bound Rails App](https://byroot.github.io/ruby/performance/2025/01/23/the-mythical-io-bound-rails-app.html) - Статья для спойкойного чтения про CPU / IO и сложности анализа;
- [Scaling Ruby Apps to 1000 Requests per Minute - A Beginner's Guide](https://www.speedshop.co/2015/07/29/scaling-ruby-apps-to-1000-rpm.html) - Старенькая статя, подробно разбирающая на что обращать внимание при масштабировании обработки HTTP-запросов;
- [Rack for Ruby: Socket Hijacking](https://blog.appsignal.com/2024/11/20/rack-for-ruby-socket-hijacking.html) - Еще немного про Falcon и Rack Hijack