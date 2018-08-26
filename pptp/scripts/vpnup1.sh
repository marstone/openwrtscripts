teardown_wall() {
        ip route del default via $PPP_REMOTE

        CHKIPSET=$(ipset -L china | wc -l)
        if [ "$CHKIPSET" == "0" ]; then
                ipset -N china nethash --hashsize 16384

                # for IP in $(wget -O - http://www.ipdeny.com/ipblocks/data/countries/cn.zone)
                for IP in $(cat /etc/config/cn.zone)
                do
                        ipset -A china $IP
                done

                ipset -A china 10.0.0.0/8
                ipset -A china 172.16.0.0/12
                ipset -A china 192.168.0.0/16
        fi

        CHKIPSET=$(ipset -L whiteip | wc -l)
        if [ "$CHKIPSET" == "0" ]; then
                ipset -N whiteip iphash --hashsize 128
                for IP in $(cat /etc/config/ip.whitelist)
                do
                        ipset -A whiteip $IP
                done
        fi

        iptables -t mangle -A PREROUTING -p tcp -m set --match-set ! whiteip src -m set --match-set ! whiteip dst -m set --match-set ! china dst -m multiport --dports 53,80,443 -j MARK --set-mark 0xffff
        iptables -t mangle -A PREROUTING -p udp -m set --match-set ! whiteip src -m set --match-set ! whiteip dst -m set --match-set ! china dst --dport 53 -j MARK --set-mark 0xffff

        iptables -t mangle -A OUTPUT -p tcp -m set --match-set ! whiteip src -m set --match-set ! whiteip dst -m set --match-set ! china dst -m multiport --dports 53,80,443 -j MARK --set-mark 0xffff
        iptables -t mangle -A OUTPUT -p udp -m set --match-set ! whiteip src -m set --match-set ! whiteip dst -m set --match-set ! china dst --dport 53 -j MARK --set-mark 0xffff

        iptables -t mangle -A FORWARD -p tcp -m set --match-set ! whiteip src -m set --match-set ! whiteip dst -m set --match-set ! china dst -m multiport --dports 53,80,443 -j MARK --set-mark 0xffff
        iptables -t mangle -A FORWARD -p udp -m set --match-set ! whiteip src -m set --match-set ! whiteip dst -m set --match-set ! china dst --dport 53 -j MARK --set-mark 0xffff

        CHKIPROUTE=$(grep wall /etc/iproute2/rt_tables)
        if [ -z "$CHKIPROUTE" ]; then
                echo "11 wall" >> /etc/iproute2/rt_tables
        fi

        ip route add table wall default via $PPP_LOCAL
        ip rule add fwmark 0xffff table wall priority 1
}

if [ "$PPP_IFACE" == "pptp-wall" ]; then
        teardown_wall
fi