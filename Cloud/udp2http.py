import socket, requests, json, sqlite3
from apns import APNs, Frame, Payload

mapping = {'b6:27:eb:ef:fc:e9':'RPi_1','b7:27:eb:ef:fc:e9':'RPi_2','b8:27:eb:ba:a9:bc':'RPi_3','b9:27:eb:ef:fc:e9':'RPi_4'}
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.bind(('0.0.0.0', 5000))
while True:
    rawData, addr = s.recvfrom(1024)
    url = "http://127.0.0.1"
    data = json.loads(rawData.decode('ascii'))
    addr = data.get("mac")
    data["name"]=mapping.get(addr, addr)
    data.pop("mac")
    data["level"]="normal"
    danger = False
    warning = False

    if(data['temp'] > 92):
        warning = True
        source = 'tempature'
        data["level"]="warning"
    if(data['flame'] > 50):
        danger = True
        source = 'flame'
        data["level"]="danger"

    print(data)

    requests.post(url, json.dumps(data))

    if danger:
        apns = APNs(use_sandbox=True, cert_file='ck.pem', key_file='key.pem')
        token_hex = 'c6a662f39ef69e2b7dd4f862643e2952ab1dc1aa55d053d31cf1978d1c8ca9e8'
        payload = Payload(alert=source + " is over the expect values", sound="default", badge=1)
        apns.gateway_server.send_notification(token_hex, payload)
        print("sent notification")
        danger = False
