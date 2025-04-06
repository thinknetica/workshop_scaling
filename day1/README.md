

## День 1

### Практика

- rails сервер на Puma/Passenger/Thin/Falcon
- использование ab/siege

- web-приложение
- sleep / threads / workers
- Puma / Passenger / Thin
- Нагрузочное тестирование siege / ab
- Action Cable 
- Rack Hijack / throw :async


### ДЗ

- Сделать небольшой план нагрузочного тестирования
  - приложения имеющего CPU-bound профиль нагрузки
  - приложения имеющего IO-bound профиль нагрузки
  - что-то еще?
- Выполнить тестирование с использованием ab или siege (желающие могут попробовать Yandex Tank)
- Сделать краткий отчёт с выводами в любой форме


### Доп. материалы по теме

- [The Mythical IO-Bound Rails App](https://byroot.github.io/ruby/performance/2025/01/23/the-mythical-io-bound-rails-app.html) - Статья для спойкойного чтения про CPU / IO и сложности анализа;
- [Scaling Ruby Apps to 1000 Requests per Minute - A Beginner's Guide](https://www.speedshop.co/2015/07/29/scaling-ruby-apps-to-1000-rpm.html) - Старенькая статя, подробно разбирающая на что обращать внимание при масштабировании обработки HTTP-запросов;
