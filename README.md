# Testes da API Restful-Booker com Robot Framework 🐾

Este repositório contém testes automatizados da **API Restful-Booker** usando **Robot Framework** e as bibliotecas **RequestsLibrary** e **Collections**.  
Os testes realizados neste projeto são apenas com **GET** e **POST**, sem necessidade de autenticação.

---

## Pré-requisitos

Antes de rodar os testes, você precisa ter instalado:

- [Python 3.x](https://www.python.org/)
- [Robot Framework](https://robotframework.org/)
- Bibliotecas necessárias: RequestsLibrary e Collections

## Test Cases

### 1. GET todos os Bookings

**Objetivo:** Listar todos os booking IDs existentes.

**Passos:**

1. Criar uma sessão HTTP com `Create Session`.
2. Fazer um GET na rota `/booking` usando `GET On Session`.
3. Validar se o status code retornado é 200.
4. Logar a lista de bookings no console.

---

### 2. POST Create Booking

**Objetivo:** Criar um novo booking.

**Passos:**

1. Criar uma sessão HTTP com `Create Session`.
2. Criar o dicionário com as datas do booking (`booking_dates`) usando **Collections**.
3. Criar o dicionário principal do booking (`booking_data`) usando **Collections**, contendo:
   - `firstname`, `lastname`
   - `totalprice`, `depositpaid`
   - `bookingdates` (checkin e checkout)
   - `additionalneeds`
4. Fazer um POST na rota `/booking` usando `POST On Session`.
5. Validar se o status code retornado é 200 ou 201.
6. Logar o booking criado e o `bookingid` no console.






```bash
pip install robotframework-requests



