

## День 1

Веб-серверы, rack-приложение, потоки/процессыю

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