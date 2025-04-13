# Задание 2. Кэширование

## Добавил метод cached_heavy_query с имитацией тяжелого запроса в контроллер metrics#cached_heavy_query
Запрос "засыпает" на 5 секунд.

## Прописал путь в маршрутах:
- get '/cached_heavy_query', to: "metrics#cached_heavy_query"

## Провёл нагрузочное тестирование: 
- Сначала запустил сервер с помощью команды rails server
- Запустил 2 запроса
- siege -c 1 -r 1 http://localhost:3000/cached_heavy_query

## Результаты в консоли после 1-го запроса:
- Transactions:		           	   1 hits
- Availability:		      	  100.00 %
- Elapsed time:		        	5.11 secs
- Data transferred:	        	0.00 MB
- Response time:		        5.11 secs
- Transaction rate:	        	0.20 trans/sec
- Throughput:		            0.00 MB/sec
- Concurrency:		        	   1.00
- Successful transactions:         1
- Failed transactions:	           0
- Longest transaction:	        5.11
- Shortest transaction:	        5.11

## Результаты в консоли после 2-го запроса (закэшированного):
- Transactions:		           	   1 hits
- Availability:		      	  100.00 %
- Elapsed time:		        	0.01 secs
- Data transferred:	        	0.00 MB
- Response time:		        0.01 secs
- Transaction rate:	      	  100.00 trans/sec
- Throughput:		        	0.00 MB/sec
- Concurrency:		        	1.00
- Successful transactions:         1
- Failed transactions:	           0
- Longest transaction:	        0.01
- Shortest transaction:	        0.01

## Результаты на /metrics после осады:
# Количество успешных запросов:
http_server_request_duration_seconds_count{method="get",path="/cached_heavy_query"} 2.0

# Длительность обработки:
http_server_request_duration_seconds_sum{method="get",path="/cached_heavy_query"} 5.031121450998398

## Выводы:
- Первый запрос: ~5 секунд (тяжёлый sleep(5))
- Второй: мгновенный (результат взят из кэша)
- Кэш сработал после первого запроса, т.е. запрос отработал за 0.01 сек.
