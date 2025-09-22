*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           BuiltIn

*** Variables ***
${BASE_URL}       https://restful-booker.herokuapp.com/
${USERNAME}       admin
${PASSWORD}       password123
${BOOKING_ID}     ${EMPTY}

*** Test Cases ***

GET todos os Bookings
    [Documentation]    Este teste faz um GET para listar todos os booking IDs existentes
    Criar Sessao Booker
    ${response}=    Listar Todos os Bookings
    Validar Status Code    ${response}    200
    Log To Console    Lista de bookings: ${response.json()}

POST Create Booking
    [Documentation]    Este teste cria um novo booking usando POST
    Criar Sessao Booker
    ${booking_data}=    Criar Dados do Booking    Kaua    Silva    123    ${True}    2025-09-20    2025-09-25    Breakfast
    ${response}=    Criar Booking    ${booking_data}
    Validar Status Code Criacao    ${response}
    ${booking_id}=    Extrair Booking ID    ${response}
    Log To Console    ID do booking criado: ${booking_id}
    Set Global Variable    ${BOOKING_ID}    ${booking_id}

GET Booking por ID
    [Documentation]    Este teste busca um booking específico por ID
    Criar Sessao Booker
    ${response}=    Buscar Booking por ID    ${BOOKING_ID}
    Validar Status Code    ${response}    200
    Validar Dados do Booking    ${response}    Kaua    Silva
    Log To Console    Booking encontrado: ${response.json()}

PUT Update Booking
    [Documentation]    Este teste atualiza um booking existente
    Criar Sessao Booker
    ${token}=    Criar Token de Autenticacao
    ${booking_data}=    Criar Dados do Booking    João    Santos    200    ${False}    2025-10-01    2025-10-05    Lunch
    ${response}=    Atualizar Booking    ${BOOKING_ID}    ${booking_data}    ${token}
    Validar Status Code    ${response}    200
    Validar Dados do Booking    ${response}    João    Santos
    Log To Console    Booking atualizado: ${response.json()}

DELETE Booking
    [Documentation]    Este teste deleta um booking
    Criar Sessao Booker
    ${token}=    Criar Token de Autenticacao
    ${response}=    Deletar Booking    ${BOOKING_ID}    ${token}
    Validar Status Code    ${response}    201
    Log To Console    Booking deletado com sucesso

*** Keywords ***
Criar Sessao Booker
    [Documentation]    Cria uma sessão HTTP para a API do Booker
    Create Session    booker    ${BASE_URL}

Listar Todos os Bookings
    [Documentation]    Faz GET para listar todos os booking IDs
    ${response}=    GET On Session    booker    /booking
    RETURN    ${response}

Criar Dados do Booking
    [Documentation]    Cria o dicionário com os dados do booking
    [Arguments]    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}
    ${booking_dates}=    Create Dictionary    checkin=${checkin}    checkout=${checkout}
    ${booking_data}=    Create Dictionary
    ...    firstname=${firstname}
    ...    lastname=${lastname}
    ...    totalprice=${totalprice}
    ...    depositpaid=${depositpaid}
    ...    bookingdates=${booking_dates}
    ...    additionalneeds=${additionalneeds}
    RETURN    ${booking_data}

Criar Booking
    [Documentation]    Faz POST para criar um novo booking
    [Arguments]    ${booking_data}
    ${response}=    POST On Session    booker    /booking    json=${booking_data}
    RETURN    ${response}

Validar Status Code
    [Documentation]    Valida se o status code está correto
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}

Validar Status Code Criacao
    [Documentation]    Valida se o status code de criação está correto (200 ou 201)
    [Arguments]    ${response}
    Should Be True    ${response.status_code} == 200 or ${response.status_code} == 201

Extrair Booking ID
    [Documentation]    Extrai o ID do booking da resposta
    [Arguments]    ${response}
    ${booking_id}=    Set Variable    ${response.json()['bookingid']}
    RETURN    ${booking_id}

Buscar Booking por ID
    [Documentation]    Busca um booking específico por ID
    [Arguments]    ${booking_id}
    ${response}=    GET On Session    booker    /booking/${booking_id}
    RETURN    ${response}

Criar Token de Autenticacao
    [Documentation]    Cria token de autenticação para operações PUT/DELETE
    ${auth_data}=    Create Dictionary    username=${USERNAME}    password=${PASSWORD}
    ${response}=    POST On Session    booker    /auth    json=${auth_data}
    ${token}=    Set Variable    ${response.json()['token']}
    RETURN    ${token}

Atualizar Booking
    [Documentation]    Atualiza um booking existente
    [Arguments]    ${booking_id}    ${booking_data}    ${token}
    ${headers}=    Create Dictionary    Cookie=token=${token}
    ${response}=    PUT On Session    booker    /booking/${booking_id}    json=${booking_data}    headers=${headers}
    RETURN    ${response}

Deletar Booking
    [Documentation]    Deleta um booking
    [Arguments]    ${booking_id}    ${token}
    ${headers}=    Create Dictionary    Cookie=token=${token}
    ${response}=    DELETE On Session    booker    /booking/${booking_id}    headers=${headers}
    RETURN    ${response}

Validar Dados do Booking
    [Documentation]    Valida se os dados do booking estão corretos
    [Arguments]    ${response}    ${expected_firstname}    ${expected_lastname}
    Should Be Equal    ${response.json()['firstname']}    ${expected_firstname}
    Should Be Equal    ${response.json()['lastname']}    ${expected_lastname}