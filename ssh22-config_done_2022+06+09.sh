#!/bin/bash
#!/bin/sh
#**************************************************************************************#
par_sh()
{

cat << "EOF" > ./par.sh
#!/bin/bash
#!/bin/sh
echo -e "\n\n"
par0=`ps|grep "yum" >/dev/null 2>&1;echo $?`
while [ "$par0" == "0" ];
	do
		sleep 0.1 && echo -ne "\r\\		Activity: \\		001%  . "&&
		sleep 0.1 && echo -ne "\r|		Activity: |		004%  .. "&&
		sleep 0.1 && echo -ne "\r/		Activity: /		009%  ... "&&
		sleep 0.1 && echo -ne "\r-		Activity: -		013%  .... "&&
		sleep 0.1 && echo -ne "\r\\		:Active:  \\		020%  ..... "&&
		sleep 0.1 && echo -ne "\r|		:aCtive:  |		027%  ...... "&&
		sleep 0.1 && echo -ne "\r/		:acTive:  /		030%  ....... "&&
		sleep 0.1 && echo -ne "\r-		:actIve:  -		042%  ........ "&&
		sleep 0.1 && echo -ne "\r\\		:actiVe:  \\		050%  ......... "&&
		sleep 0.1 && echo -ne "\r|		:activE:  |		061%  .......... "&&
		sleep 0.1 && echo -ne "\r/		:activE:  /		073%  ........... "&&
		sleep 0.1 && echo -ne "\r-		:actiVe:  -		080%  ............ "&&
		sleep 0.1 && echo -ne "\r\\		:actIve:  \\		084%  ............. "&&
		sleep 0.1 && echo -ne "\r|		:acTive:  |		090%  .............. "&&
		sleep 0.1 && echo -ne "\r/		:aCtive:  /		096%  ............... "&&
		sleep 0.1 && echo -ne "\r-		:Active:  -		100%  ................ ";
		par1=`ps|grep "yum" >/dev/null 2>&1;echo $?`
		if [ "$par1" == "1" ];then
		break
		sleep 1
		echo -e "\n\r"
		echo "Yum install Or Update >>>: OK."
		echo -e "\n\r"
		exit 1
		fi
	done
EOF

}
#**************************************************************************************#

#.........................SSH2D_Yum_install()............................#
SSH2D_Yum_install()
{

echo -e "\n脚本开始Start.....!\n"
# shellcheck disable=SC2196
host_IP="$(ip a|grep inet|grep -v inet6|grep -v 127|egrep -o "([0-9]{1,3}\.){3}[0-9]{1,3}"|head -n -1)"
echo -e "$host_IP\n"
echo -e '\n'
echo "$now_date"
hostname_IP="$(curl -s cip.cc | head -n 1 | awk '{print $1"="$3}')"
hostname_UNIP="$(curl -s cip.cc | head -n 1 | awk '{print $3}')"
echo -e '\n'
echo "$hostname_IP"
sshd_config_log="$(pwd)/sshd.$now_date.log"
echo -e '\n'
echo "root用户权限运行"
# 端口运行情况
if rpm -qa |grep net-tools >> "$sshd_config_log";
then
	echo -e '\n'
	echo "net-tools 已经安装"
	echo "net-tools 已经安装" >> "$sshd_config_log"
else
	bash par.sh & yum install -y net-tools | xargs -L 28 | xargs -I@ echo -ne "\n\r#...Yum Install. [########################################][  OK  ]\n\r"
# 	bash par.sh & yum install -y net-tools | echo -ne "\n\n#...Yum Install. [########################################][  OK  ]\n\n"
	echo -e "\n\n"
	echo "Yum install net-tools 已经安装"
	echo -e "\n\n"
fi

if rpm -qa |grep policycoreutils-python;
then
	echo -e '\n'
	echo "policycoreutils-python 已经安装"
	echo "policycoreutils-python 已经安装" >> "$sshd_config_log"
else
	bash par.sh & yum install -y policycoreutils-python | xargs -L 28 | xargs -I@ echo -ne "\r\n#...Yum Install. [########################################][  OK  ]\n\r"
	echo -e "\n\n"
	echo "Yum install policycoreutils-python 已经安装"
	echo -e "\n\n"
fi

}
#.........................SSH2D_Yum_install()............................#

#.............................SSH2D_Port()...............................#
SSH2D_Port()
{

# 换1行
n="$(echo -e '\n')"
# 换2行
# shellcheck disable=SC2034
_2n="$(echo -e '\n\n')"
#打印端口
echo "等待......1.8s" && sleep 1.8
echo "^v^请按回车键'Enter'后,输入端口......^v^"
while :;do
	netstat -antlp
	echo "$n"
	echo "
		*常见协议端口: (SSH不要使用以下端口)
		21              ftp/tftp/vsftpd文件传输协议   22                ssh远程连接
		23              Telnet远程连接                25                SMTP邮件服务
		53              DNS域名解析系统               67/68             dhcp服务
		110             pop3                          139               Samba服务
		143             Imap协议                      161               SNMP协议
		389             Ldap目录访问协议              445               smb
		512/513/514     Linux Rexec服务               873               Rsync服务
		1080            socket                        1433              mssql
		1352            Lotus domino邮件服务          2049              Nfs服务
		1521            oracle                        2375              docker remote api
		2181            zookeeper服务                 3389              Rdp远程桌面链接
		3306            mysql                         5000              sybase/DB2数据库
		4848            GlassFish控制台               5632              pcanywhere服务
		5432            postgresql                    6379              Redis数据库
		5900            vnc                           8069              zabbix服务
		7001/7002       weblogic                      8080/8089         Jboss/Tomcat/Resin
		80/443          http/https                    9000              fastcgi
		8161            activemq                      9200/9300         elasticsearch
		8083/8086       influxDB                      27017/27018       mongodb
		9090            Websphere控制台               11211             memcached
		"
# 	echo $n
	echo "	0            不使用
	1--1023      系统保留,只能由root用户使用;
	1024---4999  由客户端程序自由分配;
	5000---65535 由服务器端程序自由分配;

	提示：请输入端口数[1-65535],不含其它字符."
	echo "$n"
	read -r -ep "输入SSh 可用远程端口[4位数以上的高端口]: " sshd_port
	[[ $sshd_port =~ ^[[:digit:]]+$ ]] || continue
	(( ( (sshd_port=(10#$sshd_port)) <= 65535 ) && sshd_port > 0 )) || continue
	semanage port -a -t ssh_port_t -p tcp "$sshd_port"
	selinx_ssh_port_check0="$(semanage port -l |grep 'ssh_port_t')"
	port_check0="$(echo "$selinx_ssh_port_check0"|grep "$sshd_port" > /dev/null 2>&1;echo $?)"
	echo "$port_check0"
	if [ "$port_check0" -eq "1" ]
	then
		echo "输入SSH端口不可用: \"$sshd_port\""
	else
		echo "ssh端口是可以使用: \"$sshd_port\" ^V^ ^R^"
		break
	fi
done

}
#.............................SSH2D_Port()...............................#

#.........................SSH2D_Port_Config()............................#
SSH2D_Port_Config()
{

# shellcheck disable=SC2062
if grep -nE '^Port '[0-9][0-9]*'' "$path_sshd";
then
	sed -i '/^Port '[0-9][0-9]*'/s/'[0-9][0-9]*'/'"$sshd_port"'/' "$path_sshd"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^Port $sshd_port"
		# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^Port $sshd_port" >> "$sshd_config_log"
else
	sed -i  '/^#Port '[0-9][0-9]*'/c\Port '"$sshd_port"'' "$path_sshd"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^Port $sshd_port"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^Port $sshd_port" >> "$sshd_config_log"
fi
# shellcheck disable=SC2062
grep -nE '^Protocol '[0-9][0-9]*'' "$path_sshd"
if [ "$?" -eq "1" ]
then
	sed -i '2a Protocol 2' "$path_sshd"
	# shellcheck disable=SC2002
	number_sed="$(cat $path_sshd|grep -nE "^Protocol 2"|sed -n 1p|sed 's/:Protocol 2//')"
	printf "$number_sed%s\n"
	sed -i "$number_sed c #Protocol 2" "$path_sshd"
	sed -i '/^Protocol 2/d' "$path_sshd"
	sed -i "$number_sed c Protocol 2" "$path_sshd"
	sed -i '/^#Protocol 2/d' "$path_sshd"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^Protocol 2"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^Protocol 2" >> "$sshd_config_log"
else
	sed -i '/^Protocol */c\Protocol 2' "$path_sshd"
	# shellcheck disable=SC2002
	number_sed="$(cat $path_sshd|grep -nE "^Protocol 2"|sed -n 1p|sed 's/:Protocol 2//')"
	printf "$number_sed%s\n"
	sed -i "$number_sed c #Protocol 2" "$path_sshd"
	sed -i '/^Protocol 2/d' "$path_sshd"
	sed -i "$number_sed c Protocol 2" "$path_sshd"
	sed -i '/^#Protocol 2/d' "$path_sshd"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^Protocol 2"
		# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^Protocol 2" >> "$sshd_config_log"
fi

if grep -nE '^PermitRootLogin yes|^PermitRootLogin no' "$path_sshd";
then
	sed -i '/^PermitRootLogin yes/c\PermitRootLogin no' "$path_sshd"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^PermitRootLogin no"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^PermitRootLogin no" >> "$sshd_config_log"
else
	sed -i  '/^#PermitRootLogin yes/c\PermitRootLogin no' "$path_sshd"
	sed -i  '/^#PermitRootLogin no/c\PermitRootLogin no' "$path_sshd"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^PermitRootLogin no"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^PermitRootLogin no" >> "$sshd_config_log"
fi
# MaxAuthTries #

if grep -nE '^MaxAuthTries *' "$path_sshd";
then
	sed -i '/^MaxAuthTries */c\MaxAuthTries 3' "$path_sshd"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^MaxAuthTries 3"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^MaxAuthTries 3" >> "$sshd_config_log"
else
	sed -i '/^#MaxAuthTries */c\MaxAuthTries 3' "$path_sshd"
	grep -nE '^MaxAuthTries *' $path_sshd
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^MaxAuthTries *" >> "$sshd_config_log"
fi
# LoginGraceTime #

if grep -nE '^LoginGraceTime *' "$path_sshd";
then
	sed -i '/^LoginGraceTime */c\LoginGraceTime 30' "$path_sshd"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^LoginGraceTime 30"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^LoginGraceTime 30" >> "$sshd_config_log"
else
	sed -i '/^#LoginGraceTime */c\LoginGraceTime 30' "$path_sshd"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^LoginGraceTime 30"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^LoginGraceTime 30" >> "$sshd_config_log"
fi
sshd -t
# ClientAliveInterval #

if grep -nE '^ClientAliveInterval *' "$path_sshd";
then
	sed -i '/^ClientAliveInterval */c\ClientAliveCountMax 60' "$path_sshd"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^ClientAliveCountMax 60"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^ClientAliveCountMax 60" >> "$sshd_config_log"
else
	sed -i '/^#ClientAliveInterval */c\ClientAliveCountMax 60' "$path_sshd"
	grep -nE '^ClientAliveInterval *' $path_sshd
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^ClientAliveCountMax 60" >> "$sshd_config_log"
fi
# ClientAliveCountMax #
if grep -nE '^ClientAliveCountMax *' "$path_sshd";
then
	sed -i '/^ClientAliveCountMax */c\ClientAliveCountMax 3' "$path_sshd"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^ClientAliveCountMax 3"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^ClientAliveCountMax 3" >> "$sshd_config_log"
else
	sed -i '/^#ClientAliveCountMax */c\ClientAliveCountMax 3' "$path_sshd"
	grep -nE '^ClientAliveCountMax *' "$path_sshd"
	# shellcheck disable=SC2002
	cat $path_sshd|grep -nE "^ClientAliveCountMax 3" >> "$sshd_config_log"
fi

}
#.........................SSH2D_Port_Config()............................#

#..............................useradd_SSH().............................#
useradd_SSH()
{

while :;do
echo "$n"
echo "添加用户名非含特殊字符 空格:;#+=/|?\!<>()[]{}~*%@#^&\`\"\',"
echo "$n"
echo "添加用户名可含特殊字符 -_. 注：用户名不能纯数字|一位.|-开头,可以纯英文|其它组合形式."
echo "$n"
echo "用户名字符数量范围:[1-32]"
echo "$n"
echo "当前wheel用户组(成员)已存在SSH2协议登录用户名: xx xx,xx xx,xx,xx : $(awk -F':' '/wheel/{print $4}' /etc/group)"
echo "$n"
read -r -e -p "现在添加 SSH (wheel:su root)用户名: "  -n 32 useradd_noroot
other_useradd0="$(echo "$useradd_noroot"|grep -E "^\."|wc -L)"
other_useradd1="$(echo "$useradd_noroot"|grep "^\-" > /dev/null 2>&1;echo $?)"
other_useradd2="$(echo "$useradd_noroot"|grep -E "^\.."|wc -L)"
# shellcheck disable=SC2154
other_useradd_equal0="$(echo "$useradd_noroot"|awk -v RS="@#$j" '{print gsub(/[0-9]/,"&")}')"
other_useradd_equal1="$(echo "$useradd_noroot"|wc -L)"
useradd_name="$(useradd "$useradd_noroot" >/dev/null 2>&1;echo $?)"
if [ "$useradd_name" == "9" ]
then
	echo "whell组.已添加用户: \"""$useradd_noroot""\""
else
	echo "whell组.可添加用户: \"""$useradd_noroot""\""
fi
id "$useradd_noroot"
useradd_id="$?"
printf "\n"
number_usaeradd="$(echo "$useradd_noroot" | awk '{print length($0)}')"
[[ $number_usaeradd =~ ^[[:digit:]]+$ ]] || continue
(( ( (number_usaeradd=(10#$number_usaeradd)) <= 32 ) && number_usaeradd > 0 )) || continue
# shellcheck disable=SC2196
echo "$useradd_noroot"|egrep -E ":|;|\#|\+|\=|\?|\!|<|>|\(|\)|\[|\]|~|%|@|#|\^|&|,|'|\`|\||\*|\{|}|\/|\""
number_true1="$?"
echo "$useradd_noroot"|grep '\$'
number_true2="$?"
echo "$number_true1"
echo "$number_true2"
if (( number_true1 == 1 && number_true2 == 1 && other_useradd0 != 1 && other_useradd1 == 1 && other_useradd2 != 2 && other_useradd_equal0 != other_useradd_equal1 && useradd_id ==0 && useradd_name != 3))
then
	echo "useradd:\"""$useradd_noroot""\" is TRUE  ^v^.....[YES]."
	break
else
	echo "useradd:\"""$useradd_noroot""\" is Error ^x^.....[NO!]."
fi
done
while :;do
	read -r -e -p "
	SSH (wheel)用 户: \"""$useradd_noroot""\"
	SSH (wheel)密 码: " -n 79 passwd_noroot
        echo -e "输入密码前: \"""$passwd_noroot""\""
        echo -e "输入密码前: \"""$passwd_noroot""\"" >> "$sshd_config_log"
        passwd_nu="$(echo -e "$passwd_noroot" | awk -r '{ gsub(/\x00|\x01|\x02|\x03|\x04|\x05|\x06|\x07|\x08|\x09|\x0A|\x0B|\x0C|\x0D|\x0E|\x0F|\x10|\x11|\x12|\x13|\x14|\x15|\x16|\x17|\x18|\x19|\x1A|\x1B|\x1C|\x1D|\x1E|\x1F|\x7F|\\[2~|\\[2|\\[F|\\[6~|\\[D|\\[C|\\[H|\\[A|\\[5~|\\[3~|\\[B|\\[18~|\\[19~|\\[24~|\|\|\r/,""); print $0 }')"
        # "\x20"是空格;"\x0"是10进制,"\x00"是16进制,本次采用16进制把ASCII转码丢弃掉"".
        # passwd_nu="$(echo -e "$passwd_noroot" | awk -r '{ gsub(/\x00|\x01|\x02|\x03|\x04|\x05|\x06|\x07|\x08|\x09|\x0A|\x0B|\x0C|\x0D|\x0E|\x0F|\x10|\x11|\x12|\x13|\x14|\x15|\x16|\x17|\x18|\x19|\x20|\x1A|\x1B|\x1C|\x1D|\x1E|\x1F|\x20|\x7F|\\[2~|\\[2|\\[F|\\[6~|\\[D|\\[C|\\[H|\\[A|\\[5~|\\[3~|\\[B|\\[18~|\\[19~|\\[24~|\|\|\r/,""); print $0 }')"
        # passwd_nu="$(echo "$passwd_noroot"|awk '{ gsub(/\\[2~|\\[2|\\[F|\\[6~|\\[D|\\[C|\\[H|\\[A|\\[5~|\\[3~|\\[B|\\[18~|\\[19~|\\[24~|\|\|\r/,"");printf $0}')"
        # passwd_nu="$(echo "$passwd_noroot"|awk '{ gsub(/\|\[2~|\[F|\[6~|\[D|\[C|\[H|\[A|\[5~|\[3~|\[B|\[18~|\[19~|\[24~|\|\r/,"");printf $0}')"
        # passwd_nu="$(echo "$passwd_nun"|sed 's/\r//g')"
        echo -e "输入密码后: \"""$passwd_nu""\""
        echo -e "输入密码后: \"""$passwd_nu""\"" >> "$sshd_config_log"
      	passwd_number="$(echo "$passwd_nu" | awk '{print length($0)}')"
     	echo -e "密码字符数: \"""$passwd_number""\""
        echo -e "密码字符数: \"""$passwd_number""\"" >> "$sshd_config_log"
	[[ $passwd_number =~ ^[[:digit:]]+$ ]] || continue
	(( ( (passwd_number=(10#$passwd_number)) <= 79 ) && passwd_number > 0 )) || continue
	break
done

echo "$passwd_nu"|passwd "$useradd_noroot" --stdin

}
#..............................useradd_SSH().............................#

#............................ETC_PAM_D_SU()..............................#
ETC_PAM_D_SU()
{

if grep -nE '^auth		required	pam_wheel.so use_id' "$su_pwd";
then
	echo "auth		required	pam_wheel.so use_id,TURE!"
	echo "auth		required	pam_wheel.so use_id,TURE!" >> "$sshd_config_log"
else
	echo "auth		required	pam_wheel.so use_id" >> "$su_pwd"
	# shellcheck disable=SC2002
	cat $su_pwd|grep -nE "^auth		required	pam_wheel.so use_id"
	# shellcheck disable=SC2002
	cat $su_pwd|grep -nE "^auth		required	pam_wheel.so use_id" >> "$sshd_config_log"
fi
usermod -G wheel "$useradd_noroot"
groupadd wheel

if grep -nE '^auth		required	pam_wheel.so group=wheel' "$su_pwd";
then
	echo "auth		required	pam_wheel.so group=wheel,TURE!"
	echo "auth		required	pam_wheel.so group=wheel,TURE!" >> "$sshd_config_log"
else
	echo "auth		required	pam_wheel.so group=wheel" >> "$su_pwd"
	# shellcheck disable=SC2002
	cat $su_pwd|grep -nE "^auth		required	pam_wheel.so group=wheel"
	# shellcheck disable=SC2002
	cat $su_pwd|grep -nE "^auth		required	pam_wheel.so group=wheel" >> "$sshd_config_log"
fi

usermod -G wheel "$useradd_noroot"
groupadd wheel

}
#............................ETC_PAM_D_SU()..............................#

#............................ETC_PROFILE()...............................#
ETC_PROFILE()
{

if grep -nE '^HISTSIZE=*' "$whoamiAI";
then
	sed -i '/^HISTSIZE=*/c\HISTSIZE=1000' "$whoamiAI"
	# shellcheck disable=SC2002
	cat $whoamiAI|grep -nE "^HISTSIZE=1000"
	# shellcheck disable=SC2002
	cat $whoamiAI|grep -nE "^HISTSIZE=1000" >> "$sshd_config_log"
else
	echo "HISTSIZE=1000" >> $whoamiAI
	# shellcheck disable=SC2002
	cat $whoamiAI|grep -nE "^HISTSIZE=1000"
	# shellcheck disable=SC2002
	cat $whoamiAI|grep -nE "^HISTSIZE=1000" >> "$sshd_config_log"
fi

if grep -nE '^TMOUT=*' "$whoamiAI";
then
	sed -i '/^TMOUT=*/c\TMOUT=360' "$whoamiAI"
	# shellcheck disable=SC2002
	cat $whoamiAI|grep -nE "^TMOUT=360"
	# shellcheck disable=SC2002
	cat $whoamiAI|grep -nE "^TMOUT=360" >> "$sshd_config_log"
	else
	echo "TMOUT=360" >> "$whoamiAI"
	# shellcheck disable=SC2002
	cat $whoamiAI|grep -nE "^TMOUT=360"
	# shellcheck disable=SC2002
	cat $whoamiAI|grep -nE "^TMOUT=360" >> "$sshd_config_log"
fi

if grep -nE "^export HISTTIMEFORMAT=\"%F %T \`whoami\`\"" "$whoamiAI";
    then
		echo "export HISTTIMEFORMAT="%F %T \`whoami\`" for $whoamiAI is write"
		# shellcheck disable=SC2002
		cat $whoamiAI|grep -nE "^export HISTTIMEFORMAT=\"%F %T \`whoami\`\""
		# shellcheck disable=SC2002
		cat $whoamiAI|grep -nE "^export HISTTIMEFORMAT=\"%F %T \`whoami\`\"" >> "$sshd_config_log"
	else
		echo "export HISTTIMEFORMAT=\"%F %T \`whoami\`\"" >> "$whoamiAI"
		echo "source $whoamiAI" >> /etc/bashrc
		echo "source $whoamiAI" >> /etc/bash_profile
		echo "source $whoamiAI" >> /etc/zshrc
		# shellcheck disable=SC1091
		source /etc/bashrc
		# shellcheck disable=SC1091
		source /etc/bash_profile
		# shellcheck disable=SC1091
		source /etc/zshrc
		# shellcheck disable=SC2002
		cat $whoamiAI|grep -nE "^export HISTTIMEFORMAT=\"%F %T \`whoami\`\""
		# shellcheck disable=SC2002
		cat $whoamiAI|grep -nE "^export HISTTIMEFORMAT=\"%F %T \`whoami\`\"" >> "$sshd_config_log"
fi

}
#............................ETC_PROFILE()...............................#

#............................IP_SSHD_CONFUG()............................#
IP_SSHD_CONFUG()
{

echo "SSH[wheel:no su root]用户名:密码 \"""$useradd_noroot""\":\"""$passwd_nu""\""
echo "SSH[wheel:no su root]用户名:密码 \"""$useradd_noroot""\":\"""$passwd_nu""\"" >> "$sshd_config_log"
echo "弹性云服务器 ECS EIP:Port \"""$hostname_UNIP""\":\"""$sshd_port""\""
echo "弹性云服务器 ECS EIP:Port \"""$hostname_UNIP""\":\"""$sshd_port""\"" >> "$sshd_config_log"
echo "弹性云服务器 ECS HIP:Port \"""$hostname_IP""\":\"""$sshd_port""\""
echo "弹性云服务器 ECS HIP:Port \"""$hostname_IP""\":\"""$sshd_port""\"" >> "$sshd_config_log"
echo "脚本日志位置：$sshd_config_log"

}
#............................IP_SSHD_CONFUG()............................#

#............................selinux_firewall()..........................#
selinux_firewall()
{

selinux_on_off="$(getenforce)"
if [ "$selinux_on_off" == "permissive" ];
then
	echo "selinux is $(getenforce)"
	semanage port -a -t ssh_port_t -p tcp "$sshd_port"
	selinx_ssh_port_check1="$(semanage port -l |grep "ssh_port_t")"
	port_check1="$(echo "$selinx_ssh_port_check1"|grep "$sshd_port" > /dev/null 2>&1;echo $?)"
	echo "$port_check1"
        if [ "$port_check1" -eq "0" ];
	    then
            echo "selinux is port \"""$sshd_port""\",Yes!!!"
            echo "selinux is port \"""$sshd_port""\",Yes!!!" >> "$sshd_config_log"
        else
            echo "selinux is port \"""$sshd_port""\",NO!!!!"
            echo "selinux is port \"""$sshd_port""\",NO!!!!" >> "$sshd_config_log"
        fi
else
	echo "selinux is $(getenforce)"
fi

if firewall-cmd --state|grep "running";
then
	iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport "$sshd_port" -j ACCEPT
	firewall-cmd --zone=public --add-port="$sshd_port"/tcp --permanent
	firewall-cmd --reload
	break_port="$(firewall-cmd --permanent --query-port="$sshd_port"/tcp)"
	if [ "$break_port" == "yes" ];
	then
		echo -e "防火墙已开启检测端口: YES!\"""$sshd_port""\"\n\n"
		echo -e "防火墙已开启检测端口: YES!\"""$sshd_port""\"\n\n" >> "$sshd_config_log"
	fi
else
	echo -e "防火墙: No running...\n\n"
	echo -e "防火墙: No running...\n\n" >> "$sshd_config_log"
fi

}
#............................selinux_firewall()..........................#

#............................SSH_Passwd_Yes()............................#
SSH_Passwd_Yes()
{

echo "
'<<< SSH LINUX >>>'"
echo -e "\n"
echo "脚本日志位置：$sshd_config_log"
echo -e "\n"
echo -e "\n"
echo "弹性云服务器 ECS EIP:Port \"""$hostname_UNIP""\":\"""$sshd_port""\""
echo "弹性云服务器 ECS EIP:Port \"""$hostname_UNIP""\":\"""$sshd_port""\"" >> "$sshd_config_log"
echo -e "\n"
echo "弹性云服务器 ECS HIP:Port \"""$host_IP""\":\"""$sshd_port""\""
echo "弹性云服务器 ECS HIP:Port \"""$host_IP""\":\"""$sshd_port""\"" >> "$sshd_config_log"
echo "
'<<< SSH LINUX >>>'
################################################################################################################################
	用户: \"""useradd""\"
	密码: \"""passwd""\"
--------------------------------------------------------------------------------------------------------------------------------
	用户: \"""$useradd_noroot""\"
	密码: \"""$sha512sum_PWD""\"
################################################################################################################################
'<<< SSH LINUX >>>'

"
# echo "最终 SSH $useradd_noroot : $sha512sum_PWD"" >> $sshd_config_log
echo "

'<<< SSH LINUX >>>'
################################################################################################################################
	用户: \"""useradd""\"
	密码: \"""passwd""\"
--------------------------------------------------------------------------------------------------------------------------------
	用户: \"""$useradd_noroot""\"
	密码: \"""$sha512sum_PWD""\"
################################################################################################################################
'<<< SSH LINUX >>>'

" >> "$sshd_config_log"

}
#............................SSH_Passwd_Yes()............................#

#............................SSH_Passwd_No().............................#
SSH_Passwd_No()
{

echo "'<<< SSH LINUX >>>'"
echo -e "\n"
echo "脚本日志位置：$sshd_config_log"
echo -e "\n"
echo "弹性云服务器 ECS EIP:Port \"""$hostname_UNIP""\":\"""$sshd_port""\""
echo "弹性云服务器 ECS EIP:Port \"""$hostname_UNIP""\":\"""$sshd_port""\"" >> "$sshd_config_log"
echo -e "\n"
echo "弹性云服务器 ECS HIP:Port \"""$host_IP""\":\"""$sshd_port""\""
echo "弹性云服务器 ECS HIP:Port \"""$host_IP""\":\"""$sshd_port""\"" >> "$sshd_config_log"
echo "
################################################################################################################################
	用户：\"""useradd""\"
	密码：\"""passwd""\"
--------------------------------------------------------------------------------------------------------------------------------
	用户：\"""$useradd_noroot""\"
	密码：\"""$passwd_nu""\"
################################################################################################################################
'<<< SSH LINUX >>>'

"

# echo "最终 SSH $useradd_noroot : $sha512sum_PWD"" >> $sshd_config_log
echo "

'<<< SSH LINUX >>>'
################################################################################################################################
	用户：\"""useradd""\"
	密码：\"""passwd""\"
--------------------------------------------------------------------------------------------------------------------------------
	用户：\"""$useradd_noroot""\"
	密码：\"""$passwd_nu""\"
################################################################################################################################
'<<< SSH LINUX >>>'

" >> "$sshd_config_log"

}
#............................SSH_Passwd_No().............................#

#..............................ssh_true()................................#
ssh_true()
{
while true
	do
	echo "
	!!!!
	安全组
	(请开放ssh端口: \"$sshd_port\")
	华为云弹性云服务器 ECS > 虚拟私有云 VPC > 访问控制 > 安全组 > 关联实例 > 配置规则 > 入方向规则 > 添加规格 >
################################################################################################################################
	优先级		策略		协议端口		类型		源地址		描述
	1  		允许		TCP  			IPV4		IP地址		sshd
					$sshd_port					0.0.0.0/0
################################################################################################################################
	!!!!
		"
		#shellcheck disable=SC1009
		read -r -e -p "是否已经添\"""$sshd_port""\"SSH远程端口到ECS:IP> \"""$host_IP""\" To .安全组'[Y/y]|[YES/Yes/yes]' ^?^: " sha512_int
		case "$sha512_int" in
			[yY][eE][sS]|[yY])
			rm -rf par.sh
			break
			;;
			*)
			printf "\n"
			echo "Error!!!请重新输入正确：[Y/y/YES/Yes/yes]|[N/n/NO/No/no]: "
			;;
		esac
	done
	echo "
################################################################################################################################
	sshd 正常启动 ^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^"
	echo "
	注意: ssh客户端断开本次不能再使用其他用户登录,请使用\"""$useradd_noroot""\"登录获取获取root权限....
	eg: [$useradd_noroot@localhost ~]$ su root
	    Password: xxx
	    [root@localhost $useradd_noroot]# cd
	    [root@localhost ~]#
	sshd 正常启动 ^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^^V^
################################################################################################################################"
	printf "\n"

}
#..............................SSH_true()................................#

#------------------------------sshd_check()------------------------------#
sshd_check()
{

systemctl restart sshd && /bin/systemctl restart sshd.service > /dev/null  2>&1
if [ "$?" -eq "1" ]
then
	setenforce 0
	/bin/systemctl restart sshd.service
	setenforce 1
	netstat -antlp |grep -E "sshd|$sshd_port"
	echo "	下次启动请临时关闭: setenforce 0 再重启 /bin/systemctl restart sshd.service 再开启 setenforce 1
	否则报错: Job for sshd.service failed because the control process exited with error code. See \"systemctl status sshd.service\" and \"journalctl -xe\" for details."
else
	netstat -antlp|grep "$sshd_port"
	sshd_true1="$?"
	curl -s localhost:"$sshd_port"|grep "^SSH*"
	sshd_true2="$?"
	echo "$sshd_true1"
	echo "$sshd_true2"
	   if (( sshd_true1 == 0 && sshd_true2 == 0 ))
       then
       ssh_true
	   else
       systemctl restart sshd
       echo "Please check port in sshd_config : systemctl restart sshd!!! ^x^ ^x^ ^x^"
       fi
fi

}
#------------------------------sshd_check()------------------------------#

#****************************************While_Ture()**********************************************#
While_Ture()
{
while true
do
	read -r -e -p "是否需要对用户：\"$useradd_noroot\" 进行密码请输入 '[Y/y]|[YES/Yes/yes]' '[N/n]|[NO/No/no]' >>> input && enter <<< >?:  " sha512_int
	case $sha512_int in
		[yY][eE][sS]|[yY])
# Linux用户密码: 1 =< passwd <80
		echo -e "LINUX 用户远程密码:最少1位,最多79位字符\n"
		sha512sum_one="$(echo "$passwd_nu$now_date"|sha512sum|cut -d ' ' -f1|cut -c 1-60)"
# 		sha512sum_one=`echo "$passwd_noroot$now_date"|sha512sum|cut -d ' ' -f1`
		# shellcheck disable=SC2116
		sha512sum_two="$(echo "~@^V^@#\!=.%|*:" "+[$sha512sum_one]")"
		sha512sum_PWD="$(</dev/urandom tr -dc "A-Z$sha512sum_two"|head -c 79 ;echo)"
		echo -e "sha512sum 加密密码: \"""$sha512sum_PWD""\"\n"
		echo "$sha512sum_PWD"|passwd "$useradd_noroot" --stdin

		selinux_firewall
		SSH_Passwd_Yes
		sshd_check
		cp "$sshd_config_log" "$backup""$sshd_config_log"
		break
		;;
		[nN][oO]|[nN])
		echo "SSH 用户名:密码：\"""$useradd_noroot""\":\"""$passwd_nu""\""
		echo "SSH 用户名:密码：\"""$useradd_noroot""\":\"""$passwd_nu""\"" >> "$sshd_config_log"
		selinux_firewall
		SSH_Passwd_No
		sshd_check
		cp "$sshd_config_log" "$backup""$sshd_config_log"
		exit
		;;

		*)
		printf "\n"
		echo "Error!!!请重新输入正确：[Y/y/YES/Yes/yes]|[N/n/NO/No/no]: "
		;;
	esac
done
exit 0

}

#****************************************While_Ture()**********************************************#

#.........................ssh_config_recovery()..........................#
ssh_config_recovery()
{
now_date="$(date '+%z_%Y-%m-%d_%H-%M-%S')"
path_sshd=/etc/ssh/sshd_config
su_pwd=/etc/pam.d/su
whoamiAI=/etc/profile
# 按时间/etc/ssh/sshd_config备份文件
# log_pwd=$(echo "$(pwd)")
mkdir -p /root/SSH2_ConfigBackupFile/
backup=/root/SSH2_ConfigBackupFile
mkdir -p "$backup"/etc/
mkdir -p "$backup"/etc/pam.d/
mkdir -p "$backup"/etc/ssh/
mkdir -p "$backup""$(pwd)"

cp $path_sshd "$backup""$path_sshd"."$now_date".bak
# 按时间/etc/profile备份文件
cp "$whoamiAI" "$backup""$whoamiAI"."$now_date".bak
# 按时间/etc/pam.d备份文件
cp "$su_pwd" "$backup""$su_pwd"."$now_date".bak
# 按时间/etc/pam.d备份文件

cp /etc/bashrc "$backup"/etc/bashrc."$now_date".bak

cp /etc/bash_profile "$backup"/etc/bash_profile."$now_date".bak
cp /etc/profile "$backup"/etc/profile."$now_date".bak
cp /etc/zshrc "$backup"/etc/zshrc."$now_date".bak

}
#.........................ssh_config_recovery()..........................#

##########################################################################
ssh_config_recovery
par_sh
SSH2D_Yum_install
SSH2D_Port
SSH2D_Port_Config
useradd_SSH
ETC_PAM_D_SU
ETC_PROFILE
IP_SSHD_CONFUG
While_Ture
##########################################################################
