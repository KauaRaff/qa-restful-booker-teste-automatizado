*** Settings ***
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       https://restful-booker.herokuapp.com/

*** Test Cases ***

#Teste GET todos os bookings
GET todos os Bookings
    [Documentation]    Este teste faz um GET para listar todos os booking IDs existentes
    # Criando a sessão HTTP
    Create Session    alias=booker        url=${BASE_URL}

    # Fazendo GET na rota /booking
    ${response}=      GET On Session       alias=booker        url=https://restful-booker.herokuapp.com/booking

    # Validando status code
    Should Be Equal As Integers    ${response.status_code}    200

    # Logando o resultado
    Log To Console    Lista de bookings: ${response.json()}


#  Teste POST criar booking 
POST Create Booking
    [Documentation]    Este teste cria um novo booking usando POST com automacao

    # Criando a sessão HTTP
    Create Session    booker        https://restful-booker.herokuapp.com

    
    ${booking_dates}=    Create Dictionary
    ...    checkin=2025-09-20
    ...    checkout=2025-09-25

    # Criando o principal do booking
    ${booking_data}=    Create Dictionary
    ...    firstname=Kaua
    ...    lastname=Silva
    ...    totalprice=123
    ...    depositpaid=${True}
    ...    bookingdates=${booking_dates}
    ...    additionalneeds=Breakfast

    # Fazendo POST na rota /booking usando a sessão "booker"
    ${response}=    POST On Session    booker    /booking    json=${booking_data}

    # Validando status code
    Should Be True    ${response.status_code} == 200 or ${response.status_code} == 201

    # Logando o resultado completo do POST
    Log To Console    Booking criado: ${response.json()}

    # Extraindo e logando o ID do booking criado
    ${booking_id}=    Set Variable    ${response.json()['bookingid']}
    Log To Console   ID do booking criado: ${booking_id}

*** Keywords ***