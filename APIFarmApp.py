import pycatastro as catastro
from flask import Flask, request, jsonify
from flask_cors import CORS
import subprocess
import json
import logging
from urllib.parse import quote
from geopy.geocoders import Nominatim


geolocator = Nominatim(user_agent="farmapp")
sistema: str = 'EPSG:4258'
formulaCulNit = {"Almendro":0.0097002,"Arroz":0.007973,"Avena":0.008372,"Cebada":0.004386,"Girasol":0.0144768,"Hortalizas":0.00274,"Leguminosas":0.02465,"Maíz":0.006318,"Trigo":0.003094,"Tubérculos":0.0021285,"Viñedo":0.00113933}
formulaCulPro = {"Albacete":0.005,"Alicante":0.005,"Almería":0.005,"Álava":0.006,"Asturias":0.006,"Ávila":0.005,"Badajoz":0.005,"Baleares":0.005,"Barcelona":0.005,"Bizkaia":0.006,"Burgos":0.005,"Cáceres":0.005,"Cádiz":0.005,"Cantabria":0.006,"Castellón":0.005,"Ciudad Real":0.005,"Córdoba":0.005,"A Coruña":0.006,"Cuenca":0.005,"Gipúzkoa":0.006,"Girona":0.005,"Granada":0.005,"Guadalajara":0.005,"Huelva":0.005,"Huesca":0.005,"Jaén":0.005,"León":0.006,"Lleida":0.005,"Lugo":0.006,"Madrid":0.005,"Málaga":0.005,"Murcia":0.005,"Navarra":0.006,"Ourense":0.006,"Palencia":0.005,"Las Palmas":0.005,"Pontevedra":0.006,"La Rioja":0.005,"Salamanca":0.005,"Santa Cruz de Tenerife":0.005,"Segovia":0.005,"Sevilla":0.005,"Soria":0.005,"Tarragona":0.005,"Teruel":0.005,"Toledo":0.005,"Valencia":0.005,"Valladolid":0.005,"Zamora":0.005,"Zaragoza":0.005,"Ceuta":0.005,"Melilla":0.005}
formulaFertiNit = {"Nitrato amónico": 0.34,"Nitrato de calcio": 0.15,"Nitrato de magnesio": 0.11,"Nitrato potásico": 0.13,"Sulfato amónico": 0.21,"Urea": 0.46}
formulaFertiPro = {"Albacete":0.005,"Alicante":0.005,"Almería":0.005,"Álava":0.015,"Asturias":0.016,"Ávila":0.005,"Badajoz":0.005,"Baleares":0.005,"Barcelona":0.007,"Bizkaia":0.016,"Burgos":0.009,"Cáceres":0.005,"Cádiz":0.005,"Cantabria":0.016,"Castellón":0.005,"Ciudad Real":0.005,"Córdoba":0.005,"A Coruña":0.016,"Cuenca":0.005,"Gipúzkoa":0.016,"Girona":0.010,"Granada":0.006,"Guadalajara":0.005,"Huelva":0.005,"Huesca":0.010,"Jaén":0.005,"León":0.011,"Lleida":0.010,"Lugo":0.016,"Madrid":0.012,"Málaga":0.005,"Murcia":0.005,"Navarra":0.006,"Ourense":0.016,"Palencia":0.008,"Las Palmas":0.005,"Pontevedra":0.016,"La Rioja":0.008,"Salamanca":0.006,"Santa Cruz de Tenerife":0.005,"Segovia":0.005,"Sevilla":0.005,"Soria":0.006,"Tarragona":0.005,"Teruel":0.006,"Toledo":0.005,"Valencia":0.005,"Valladolid":0.005,"Zamora":0.006,"Zaragoza":0.006,"Ceuta":0.005,"Melilla":0.005}
formulaAbono = {"Purín":{"Vacuno":0.002851,"Porcino":0.001978},"Estiércol semilíquido": {"Vacuno":0.006678,"Porcino":0.003689,"Avícola":0.01528,"Cunícola":0.0377,},"Estiércol sólido": {"Vacuno":0.008786,"Ovino":0.019227,"Porcino":0.009449,"Caprino":0.029107,"Equino":0.019825,"Avícola":0.03016,"Cunícola":0.0726,}}
formulaAbonoPro = {"Albacete":0.005,"Alicante":0.005,"Almería":0.005,"Álava":0.006,"Asturias":0.006,"Ávila":0.005,"Badajoz":0.005,"Baleares":0.005,"Barcelona":0.005,"Bizkaia":0.006,"Burgos":0.005,"Cáceres":0.005,"Cádiz":0.005,"Cantabria":0.006,"Castellón":0.005,"Ciudad Real":0.005,"Córdoba":0.005,"A Coruña":0.006,"Cuenca":0.005,"Gipúzkoa":0.006,"Girona":0.005,"Granada":0.005,"Guadalajara":0.005,"Huelva":0.005,"Huesca":0.005,"Jaén":0.005,"León":0.006,"Lleida":0.005,"Lugo":0.006,"Madrid":0.005,"Málaga":0.005,"Murcia":0.005,"Navarra":0.006,"Ourense":0.006,"Palencia":0.005,"Las Palmas":0.005,"Pontevedra":0.006,"La Rioja":0.005,"Salamanca":0.005,"Santa Cruz de Tenerife":0.005,"Segovia":0.005,"Sevilla":0.005,"Soria":0.005,"Tarragona":0.005,"Teruel":0.005,"Toledo":0.005,"Valencia":0.005,"Valladolid":0.005,"Zamora":0.005,"Zaragoza":0.005,"Ceuta":0.005,"Melilla":0.005,}
formulaRuta = {"Agrícola":{"Gasóleo":0.534},"Camión":{"Gasóleo":0.586,"Gasolina":0.673,"Gas Natural":1.117},"Furgoneta":{"Gasóleo":0.256,"Gasolina":0.259},"Turismo":{"Gasóleo":0.163,"Gasolina":0.195,"Gas Natural":0.196,"Gas Licuado":0.185}}
app = Flask(__name__)
CORS(app)

@app.route('/', methods=['GET', 'POST'])

def callback():
    if request.method == 'POST':
        input = request.get_json()
        match input['opcion']:
            case 1:
                return Coor(input)
            case 2:
                return RefCas(input)
            case 3:
                return Cultivo(input)
            case 4:
                return Fertilizante(input)
            case 5:
                return Abono (input)
            case 6:
                return Mapa (input)
            case 7:
                return ComprobarReferencia(input)

    

def Coor(input):
    consultaCoor = catastro.PyCatastro.Consulta_CPMRC(input['provincia'], input['municipio'], sistema, input['referencia'])
    try:
        longitud = consultaCoor['consulta_coordenadas']['coordenadas']['coord']['geo']['xcen']
        latitud = consultaCoor['consulta_coordenadas']['coordenadas']['coord']['geo']['ycen']
    except:
        envio = {"funciona": False}
        return jsonify(envio)
    else:
        envio = {"longitud":longitud,"latitud":latitud, "funciona": True}
        return jsonify(envio)
    
def RefCas(input):
    consultaRef = catastro.PyCatastro.Consulta_RCCOOR_Distancia(sistema,input['longitud'],input['latitud'])
    try:
        consultaRef['consulta_coordenadas_distancias']['coordenadas_distancias']['coordd']['lpcd']['pcd']['pc']['pc1']
    except KeyError:
        envio = {"funciona":False}
        return jsonify(envio)
    except TypeError:    
        referencia1 = consultaRef['consulta_coordenadas_distancias']['coordenadas_distancias']['coordd']['lpcd']['pcd'][0]['pc']['pc1']
        referencia2 = consultaRef['consulta_coordenadas_distancias']['coordenadas_distancias']['coordd']['lpcd']['pcd'][0]['pc']['pc2']
        envio = {"referencia":referencia1+referencia2,"funciona":True}
        return jsonify(envio)
    else:
        referencia1 = consultaRef['consulta_coordenadas_distancias']['coordenadas_distancias']['coordd']['lpcd']['pcd']['pc']['pc1']
        referencia2 = consultaRef['consulta_coordenadas_distancias']['coordenadas_distancias']['coordd']['lpcd']['pcd']['pc']['pc2']
        envio = {"referencia":referencia1+referencia2,"funciona":True}
        return jsonify(envio)

def Cultivo(input):
    tamTotal = 0
    Co2Cul = 0
    envio = {"cantidad": 0}
    consultaCul = catastro.PyCatastro.Consulta_DNPRC("","",input['referencia']+'0000')
    try:
        consultaCul['consulta_dnp']['bico']['lspr']['spr']['dspr']['ssp']
    except TypeError:
        for i in consultaCul['consulta_dnp']['bico']['lspr']['spr']:
            deno = i['dspr']['dcc']
            intes = i['dspr']['ip']
            tam = i['dspr']['ssp']
            tamTotal =tamTotal+int(tam)
        if input['tipo'] == "Arroz":
            Co2Cul = round((float(tamTotal)*0.0001)*161.98*28, 2)
            envio = {"cantidad": Co2Cul,"funciona":True}
            return jsonify(envio)
        else:
            Co2Cul = round(float(input['cantidad'])*formulaCulNit[input['tipo']]*formulaCulPro[input['provincia']]*(44/28)*265, 2)
            envio = {"cantidad": Co2Cul,"funciona":True}
            return jsonify(envio)

    else:
        tam = consultaCul['consulta_dnp']['bico']['lspr']['spr']['dspr']['ssp']
        if input['tipo'] == "Arroz":
            Co2Cul = round((float(tamTotal)*0.0001)*161.98*28, 2)
            envio = {"cantidad": Co2Cul,"funciona":True}
            return jsonify(envio)
        else:
            Co2Cul = round(float(input['cantidad'])*formulaCulNit[input['tipo']]*formulaCulPro[input['provincia']]*(44/28)*265, 2)
            envio = {"cantidad": Co2Cul,"funciona":True}
            return jsonify(envio)
        
def Fertilizante(input):
    envio = {"cantidad": 0}
    Co2Fer = round(float(input['cantidad'])*formulaFertiNit[input['fertilizante']]*formulaCulPro[input['provincia']]*(44/28)*265, 2)
    envio = {"cantidad": Co2Fer}
    return jsonify(envio)

def Abono(input):
    envio = {"cantidad": 0}
    Co2Est = round(float(input['cantidad'])*formulaAbono[input['abono1']][input['abono2']]*formulaAbonoPro[input['provincia']]*(44/28)*265, 2)
    envio = {"cantidad": Co2Est}
    return jsonify(envio)

def Mapa (input):
    envio = {"cantidad": 0, "mapa": ""}
    consultaCoor = catastro.PyCatastro.Consulta_CPMRC("", "", sistema, input['referencia'])
    longitudF = consultaCoor['consulta_coordenadas']['coordenadas']['coord']['geo']['xcen']
    latitudF = consultaCoor['consulta_coordenadas']['coordenadas']['coord']['geo']['ycen']
    longitudO = input['longitud']
    latitudO = input['latitud']
    try:
        location = geolocator.reverse(latitudO+","+longitudO)
    except:
        envio = {"funciona": False}
        return jsonify(envio)
    else:
        if location == None:
            envio = {"funciona": False}
            return jsonify(envio)
        else:
            address = location.raw['address']
            country = address.get('country', '')
            if country == "España":
                polilinea = subprocess.run(["curl", "https://api.mapbox.com/directions/v5/mapbox/driving/"+longitudO+","+latitudO+";"+longitudF+","+latitudF+"?exclude=motorway,toll,ferry,cash_only_tolls&geometries=polyline&access_token=pk.eyJ1IjoibHVpc2JsYW5jbzExMSIsImEiOiJjbHZ1M241aXQxYTVsMmtvZGZ2Znd1cTBhIn0.l1YwmFpgO0f7miNq161kkw"], capture_output=True, text=True)
                resultado = json.loads(polilinea.stdout)
                ruta = resultado['routes'][0]['geometry'].encode('utf-8')
                ruta2 = str(ruta)
                ruta2 = ruta2[2:-1]
                ruta2 = quote(ruta2)
                peticion = "https://api.mapbox.com/styles/v1/mapbox/streets-v12/static/pin-l-home+9ed4bd("+longitudO+","+latitudO+"),pin-l-farm+000("+longitudF+","+latitudF+"),path("+ruta2+")/auto/500x300@2x?access_token=pk.eyJ1IjoibHVpc2JsYW5jbzExMSIsImEiOiJjbHZ1M241aXQxYTVsMmtvZGZ2Znd1cTBhIn0.l1YwmFpgO0f7miNq161kkw"
                cantidad = round(resultado['routes'][0]['distance']*input['viajes']*formulaRuta[input['vehiculo']][input['combustible']],2)
                envio = {"cantidad": cantidad, "mapa": peticion,"funciona": True}
                return jsonify(envio)
            else:
                envio = {"funciona": False}
                return jsonify(envio)

def ComprobarReferencia(input):
    consultaCul = catastro.PyCatastro.Consulta_DNPRC("","",input['referencia']+'0000')
    try:
        consultaCul['consulta_dnp']['bico']
    except:
        envio = {"funciona": False}
        return jsonify(envio)
    else:
        envio = {"funciona": True}
        return jsonify(envio)

log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)

if __name__=='__main__':
    app.run(host='0.0.0.0', port=5000)