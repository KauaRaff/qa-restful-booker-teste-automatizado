*** Settings ***
Library    RequestsLibrary
Library    collections

*** Variables ***
${BOOKER_URL}        https://restful-booker.herokuapp.com
${USERNAME}          admin
${PASSWORD}          admin12345

*** Keywords ***
#para criar uma sessão na API
Criar sessao
    [Arguments]        ${alias}=booker
    Create Session        alias=${alias}        url=${BOOKER_URL}

#criando token
Gerando o Token
    Criar sessao
    ${body}=        Create Dictionary        username=${USERNAME}    password=${PASSWORD}
    ${headers}=      Create Dictionary        Content-Type=application/json

    ${resp}=    POST On Session
    ...        alias=booker
    ...        url=/auth
    ...        json=${body}
    ...        headers=${headers}
    ...        expected_status=201
    
    Log To Console    Token gerado= ${resp.json()["token"]}
    RETURN        ${resp.json()["token"]}

#criando reserva
Criar reserva
    [Arguments]    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}
    ${body}=    Create Dictionary
    ...    firstname=${firstname}
    ...    lastname=${lastname}
    ...    totalprice=${totalprice}
    ...    depositpaid=${depositpaid}
    ...    bookingdates={"checkin": "${checkin}", "checkout": "${checkout}"}
    ...    additionalneeds=${additionalneeds}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${resp}=    POST On Session
    ...    alias=booker
    ...    url=/booking
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=200
    Log To Console    Reserva criada: ${resp.json()}
    RETURN    ${resp.json()["bookingid"]}

#criando consultar reserva
Consultar reserva por ID
    [Arguments]    ${booking_id}
    ${resp}=    GET On Session
    ...    alias=booker
    ...    url=/booking/${booking_id}
    ...    expected_status=200
    Log To Console    Reserva consultada: ${resp.json()}
    RETURN    ${resp.json()}

#atualizando a reserva ja criada
Atualizar a reserva
    [Arguments]    ${booking_id}    ${token}    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}
    ${body}=    Create Dictionary
    ...    firstname=${firstname}
    ...    lastname=${lastname}
    ...    totalprice=${totalprice}
    ...    depositpaid=${depositpaid}
    ...    bookingdates={"checkin": "${checkin}", "checkout": "${checkout}"}
    ...    additionalneeds=${additionalneeds}
    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Cookie=token=${token}
    ${resp}=    PUT On Session
    ...    alias=booker
    ...    url=/booking/${booking_id}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=200
    Log To Console    Reserva atualizada: ${resp.json()}

#deletando a reserva
Deletando a reserva
    [Arguments]    ${booking_id}    ${token}
    ${headers}=    Create Dictionary    Cookie=token=${token}
    ${resp}=    DELETE On Session
    ...    alias=booker
    ...    url=/booking/${booking_id}
    ...    headers=${headers}
    ...    expected_status=201
    Log To Console    Reserva ${booking_id} deletada com sucesso
    
*** Test Cases ***
