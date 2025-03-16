#!/bin/bash

clear

# แสดงข้อมูลระบบ
system_info() {
    echo "==========================================="

    echo "รุ่น: $(lsb_release -d | awk -F: '{print $2}')"
    echo "เดือน: $(date +'%d/%m/%Y')"
    echo "เวลา: $(date +'%H:%M:%S')"
    echo "แรม: $(free -h | grep Mem | awk '{print $2}')"
    echo "แกน: $(nproc)"
    echo "==========================================="
}

# แสดงสถานะบริการ
service_status() {
    echo "Service: systemd-r Port: 53"
    echo "Service: sshd Port: 22"
    echo "Service: squid3 Port: 8080"
    echo "Service: openvpn Port: $(ss -tuln | grep ':7505' | wc -l)"
    echo "Service: apache2 Port: $(ss -tuln | grep ':80' | wc -l)"
    echo "==========================================="
}

# เมนูหลัก
while true; do
    clear
    system_info
    service_status
    echo "Please select an option:"
    echo "1) • จัดการผู้ใช้งาน"
    echo "2) • เมนูการติดตั้ง"
    echo "0) • ออกจากเมนูสคริปต์?"
    echo "==========================================="
    read -p "Enter your choice: " choice

    case $choice in
        1)
            # จัดการผู้ใช้งาน
            while true; do
                clear
                echo "==========================================="
                echo "             • จัดการผู้ใช้งาน"
                echo "==========================================="
                echo "1) • สร้างผู้ใช้งาน"
                echo "2) • ลบผู้ใช้งาน"
                echo "0) • ย้อนกลับ"
                echo "==========================================="
                read -p "Enter your choice: " user_choice

case $user_choice in
    1)
        # ดาวน์โหลดและติดตั้ง openvpn-install.sh
        wget https://raw.githubusercontent.com/muffynx/vpn/refs/heads/main/install.sh -O openvpn-install.sh && bash openvpn-install.sh
        # รอให้คำสั่งเสร็จก่อนที่จะทำงานขั้นตอนต่อไป
        wait
        ;;
    0)
        break
        ;;
    *)
        echo "Invalid option! Please try again."
        ;;
esac

            done
            ;;
        2)
            # เมนูการติดตั้ง
            while true; do
                clear
                echo "Server IP: $(hostname -I | awk '{print $1}')"
                echo "==========================================="
                echo "[01] • APACHE2 ◉            "
                echo "[02] • OPENSSH ◉            "
                echo "[03] • SQUID PROXY ◉       "
                echo "[04] • OPENVPN ◉           "
                echo "[00] • ย้อนกลับ"
                echo "==========================================="
                read -p "Enter your choice: " install_choice

                case $install_choice in
                    1)
                        # ติดตั้ง Apache2
                        sudo apt-get update
                        sudo apt-get install apache2 -y
                        ;;
                    2)
                        # ติดตั้ง OpenSSH
                        sudo apt-get update
                        sudo apt-get install openssh-server -y
                        ;;
                    3)
                        # ติดตั้ง Squid Proxy
                        read -p "Enter Squid Port (e.g., 8080): " squid_port
                        sudo apt-get update
                        sudo apt-get install squid3 -y
                        sudo ufw allow $squid_port/tcp
                        ;;
                    4)
                        # ติดตั้ง OpenVPN
                        read -p "Enter OpenVPN Port (e.g., 1720): " openvpn_port
                        read -p "Choose DNS Provider: [1] System [2] Google [3] OpenDNS: " dns_choice
                        read -p "Select Protocol: [1] UDP [2] TCP: " protocol_choice
                        sudo apt-get update
                        sudo apt-get install openvpn -y
                        sudo ufw allow $openvpn_port/tcp
                        ;;
                    0)
                        break
                        ;;
                    *)
                        echo "Invalid option! Please try again."
                        ;;
                esac
            done
            ;;
        0)
            # ออกจากเมนูสคริปต์
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option! Please try again."
            ;;
    esac
done
