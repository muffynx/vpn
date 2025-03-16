	echo
    mkdir -p /var/www/html/openvpn
    # คัดลอกไฟล์ .ovpn ที่สร้างจาก OpenVPN ไปยังไดเรกทอรีของ Apache
    cp "$script_dir"/"$client.ovpn" /var/www/html/openvpn/
    # ตั้งค่า Apache2 ให้สามารถเข้าถึงไฟล์นี้
    chmod 755 /var/www/html/openvpn/"$client.ovpn"
    # แจ้งให้ผู้ใช้รู้ว่าไฟล์พร้อมให้ดาวน์โหลดที่ไหน
    echo "The client configuration is available in: $script_dir/$client.ovpn"
    echo "Link to download: http://$ip:81/openvpn/$client.ovpn"