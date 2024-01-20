# Tornando-se root
if [ "$(whoami)" != "root" ]; then
    echo "Tornando-se superusuário..."
    sudo -E bash $0
    exit $?
fi

echo "Bem-vindo ao script de instalação do Proxmox no Debian 12 Bookworm"
echo "Este script também perguntará se você deseja instalar alguns pacotes adicionais, 
como 'nala', 'neofetch' e pacotes de ferramentas de rede: 'net-tools' e 'nmap'."

read -p "Deseja iniciar a instalação? (Digite 'sim' para continuar): " resposta

if [ "$resposta" != "sim" ]; then
    echo "Instalação cancelada. Saindo do script."
    exit 1
fi

echo "Iniciando a instalação..."

# Instalando pacotes
# nala
read -p "Deseja instalar o 'nala'? (Opcional) (Digite 'sim' para instalar): " resposta_nala

if [ "$resposta_nala" == "sim" ]; then
    echo "Iniciando a instalação do 'nala'..."
    apt install -y nala
    echo "'nala' instalado com sucesso."
else
    echo "Continuando a instalação sem 'nala'..."
fi

read -p "Deseja instalar o 'neofetch'? (Opcional) (Digite 'sim' para instalar): " resposta_neofetch

if [ "$resposta_neofetch" == "sim" ]; then
    if [ "$resposta_nala" == "sim" ]; then
        echo "Iniciando a instalação do 'neofetch' com o nala..."
        nala install -y neofetch
        echo "'neofetch' instalado com sucesso."
    else
        echo "Iniciando a instalação do 'neofetch' com o apt..."
        apt install -y neofetch
        echo "'neofetch' instalado com sucesso."
    fi
else
    echo "Continuando a instalação sem o 'neofetch'..."
fi

# ferramentas de rede
read -p "Deseja instalar as ferramentas de rede 'net-tools' e 'nmap'? (Opcional) (Digite 'sim' para instalar): " resposta_net
if [ "$resposta_net" == "sim" ]; then
    if [ "$resposta_nala" == "sim" ]; then
        echo "Iniciando a instalação do 'net-tools' & 'nmap' com o nala..."
        nala install -y nmap && nala install -y net-tools
        echo "Pacotes instalados com sucesso."
    else
        echo "Iniciando a instalação do 'net-tools' & 'nmap' com o apt..."
        apt install -y nmap && apt install -y net-tools
        echo "Pacotes instalados com sucesso."
    fi
else
    echo "Continuando a instalação sem as ferramentas de rede..."
fi

# Comandos de instalação do Proxmox
echo iniciando instalação do Proxmox

# Solicitar ao usuário o nome do host e o endereço IP
read -p "Digite o nome do host: " hostname
read -p "Digite o endereço IP: " ip_address

# Verificar se o arquivo /etc/hosts já contém uma entrada para o nome do host
if grep -q "$hostname" /etc/hosts; then
    echo "O nome do host '$hostname' já está presente no arquivo /etc/hosts."
    exit 1
fi

# Adicionar a nova entrada ao arquivo /etc/hosts
echo "$ip_address    $hostname" | sudo tee -a /etc/hosts > /dev/null

echo "Entrada adicionada com sucesso ao arquivo /etc/hosts:"
cat /etc/hosts | grep "$hostname"

# Substitua este comentário pelos comandos reais de instalação do Proxmox e outros pacotes

echo "Instalação concluída com sucesso!"
echo "Lembre-se de configurar o Proxmox conforme necessário após a instalação."