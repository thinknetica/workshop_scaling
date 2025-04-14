# Задание 3. Leader Election (Не получилось)

## Подготовительные операции
- Поставил IP-адрес 127.0.0.1 в методе определения redis
- Запустил Пуму в 3 воркера (bundle exec puma -w 3)
- Открыл дополнительно 3 вкладки и ввел команду curl http://localhost:3000/info.text

## Результаты
- * I'am: _1744642719  Pid: 31358 known leader: "_1744642718"
- * I'am: _1744642718 LEADER Pid: 31360 known leader: "_1744642718"
- * I'am: _1744642718 LEADER Pid: 31360 known leader: "_1744642718"