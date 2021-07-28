# Setup **template**

>## Création de la VM *template*

- **Nom** : `template`
- **CPU** : `1 Coeur`
- **RAM** : `2 GO`
- **OS** : `Debian Buster`
- **Carte réseau** : `Bridge`

>## Choix de logiciels addicionnels

- Inatalaltion non graphique **(Pas de GUI)**
- Sélectionner `SSH` et `standard system utilities`

>## Choix réseau

- Éteigner votre VM **template** et changer sa carte réseau en `Host Only`

>## Installations des packages utiles

### sudo

##### Installation

Aussi appelé **Super User**, ce package vous permettra de lire, mais aussi modifier ainsi qu'executer tout les fichiers présent sur votre machine. *Votre limite devient ainsi votre imagination*

1. Ecrir `su` (*Super User*), appuyer sur **Entré**
2. Entrer votre *mot de passe*, appuyer sur **Entré**
3. Ecrir `apt-get update`, appuiyer sur **Entré**
4. Une fois la mise à jour finit, ecrir `apt-get install sudo`, appuyer sur **Entré**

##### Configuration

1. Ecrir `su` (*Super User*), appuyer sur **Entré**
2. Entrer votre *mot de passe*, appuyer sur **Entré**
3. Tapé `nano /etc/sudoers`, pour accéder au fichier de configuration de la commande `sudo`
4. Identifier la ligne de code `root    ALL=(ALL:ALL) ALL`
5. Appuyer sur **Entré** a la fin de cette dernière, puis ajouter la ligne de code `user    ALL=(ALL:ALL) ALL` (*Remplacer `user`*)
6. Appuyer simultanément sur `Ctr + s`, puis `Ctr + x`
7. Pour verifier si les changements ont bien été pris en comptent, taper `sudo apt-get update`
8. Si votre *mot de passe* vous est demandé, tout c'est bien passé :)

### openssh

Ce package vous permettra de vous connecter à votre VM depuis votre terminal préféré, qui je pense aura un meilleur design que votre VM :)

1. Ecrir `su` (*Super User*), appuyer sur **Entré**
2. Entrer votre *mot de passe*, appuyer sur **Entré**
3. Ecrir `apt-get update`, appuiyer sur **Entré**
4. Une fois la mise à jour finit, ecrir `apt-get install openssh-server`, appuyer sur **Entré**
5. Pour vérifier si le package a bien été installer, ouvrer votre terminal favoris est entré `ssh user@ip` (*remplacer `user` et `ip`*) (*vous pouvez trouver votre `ip` en entrant `ip a` sur votre VM*)
6. Si votre *mot de passe* vous est demandé, c'est parfait :)

# Setup VMs

>## Création des VMs

Maintenant que notre **VM template** est prête, nous allons pouvoir commencer à créer ou devrais-je dire **Cloner** les VMs qui composeront notre réseau : `gateway`, `web` et `manager`.

1. Créer un clone de votre **VM template** pour chacune des *VMs demandé*, nommez-la.
2. Une fois la VM clone crée, voua allez devoir changer le `hostname` de cette dernière, entrer `sudo hostnamectl set-hostname new_hostname` (*remplacer `new_hostname`*)
3. Pour rendre votre changement définitif, tapez `sudo nano /etc/hosts`, un éditeur de texte devrait s'ouvrir
4. Identifier la ligne de `127.0.0.1    localhost`
5. Remplacer la ligne suivante par la ligne de code `127.0.0.1  new_hostname` (*remplacer `new_hostname`*)
6. Pour vérifier si les changements ont bien été pris en comptent, tapez `hostname`
7. Si votre `new_hostname` est indiqué, c'est que tout c'est bien passé :)

[Ressources](https://linuxize.com/post/how-to-change-hostname-on-debian-9/)

# Configuration Réseau

>## Configuration de `gateway`

#### Adaptateurs réseaux

`gateway` sera le centre de notre réseau. En effet, se sera la *VM* oû toutes les requetes vont passer. Ainsi, nous devons connecter cette dernière à Internet. 

1. Ouvrez les **configurations réseaux** de votre `gateway`
2. Modifier le premier **adaptateur réseau** en `bridge` (*précedemment, cet adaptateur devrait etre en `host-only`*)
3. Ajouter un deuxième **adaptateur réseau** en `host-only`, pour permettre a votre `gateway` et à vos autres *VMs*, de communiquer entre-elles.

#### Gestion de votre `host-only`

Vous allez devoir faire en sorte que votre `gateway`, soit le *point d'entré* et le *point de sortie* de votre réseau `host-only`.

1. Ouvrir votre **VM `gateway`**
2. Entrer `sudo nano /etc/network/interfaces`, pour acceder au paramètre de votre réseau.
3. Enter votre *mot de passe*
4. Identifier la ligne commentée `# The primary network interface`, les 2 lignes de code suivantes, configure votre **`bridge`** (*sur VM ware, la référence de votre `bridge` est *`ens33`*, sur VirtualBox, la référence de votre `bridge` est *`enp0s8`*)
5. Supprimer toutes les ligne de code se trouvant après ces 2 lignes de code
6. Configurer votre réseau **`host-only`** :
   - `# The secondary network interface`
   - `auto référence` (*remplacer `référence` par : `ens37` si vous êtes sur VMware et par `enp0s3` si vous êtes sur VirtualBox*)
   - `iface référence inet static` -> Permet de configurer une ***address ip static*** (*remplacer `référence` par : `ens37` si vous êtes sur VMware et par `enp0s3` si vous êtes sur VirtualBox*)
   - `address 192.168.0.2` -> Création de l'***address ip static***
   - `netmask 255.255.0.0` -> Configuration de l'identificateur
7. Appuyer simultanément sur `Ctr + s`, puis `Ctr + x`
8. Entrer `sudo systemctl restart networking`, pour redémarrer le réseau de votre *VM*, appuyer sur **Entré**, puis entrer votre *mot de passe*
9. Pour vérifier si les changements ont bien été pris en comptent, entrer `ip a`
10. Identifier le paragraphe avec la référence `ens37` sur VMware ou `enp0s8` sur VirtualBox (*dernier paragraphe*)
11. Si vous voyer l'***addresse ip*** `192.168.0.2`, c'est parfait :)

#### Configuration de votre réseau

Votre `gateway`, étant le centre de votre réseau, toute les requêtes venant des autres VMs du réseau, passeront par votre `gateway`. Ainsi, nous allons configurer des règles permettant de gérer ces requêtes et de les redirectionner vers les bonnes destinations

1. Ouvrir votre VM `gateway`
2. Configurer vos règles d'***iptables***, entrer les commandes suivantes
    - `sudo iptables -A FORWARD -i ens33 -j ACCEPT` -> configuration des ***input*** (*remplacer `référence` par : `ens33` si vous êtes sur VMware et par `enp0s8` si vous êtes sur VirtualBox*)
    - `sudo iptables -A FORWARD -o ens33 -j ACCEPT` -> configuration des ***output*** (*remplacer `référence` par : `ens33` si vous êtes sur VMware et par `enp0s8` si vous êtes sur VirtualBox*)
    - `sudo iptables -t nat -A POSTROUTING ! -d 192.168.0.0/16 -o ens33 -j MASQUERADE` -> configuration des redirections des requêtes (*remplacer `référence` par : `ens37` si vous êtes sur VMware et par `enp0s3` si vous êtes sur VirtualBox*)

[Ressource](https://www.digitalocean.com/community/tutorials/how-to-forward-ports-through-a-linux-gateway-with-iptables)

>## Configuration des *VMs `manager` et `web`*

#### Connexion à votre `gateway`

Comme dit précédémment, votre `gateway` sera le centre de notre réseaux. Actuellement, la seul VM de notre réseau est `gateway`, vous devrez donc configurer les réseaux de vos autres VMs pour pouvoir communiquer avec cette dernière.

1. Ouvrir un de vos *VM*
2. Entrer `sudo nano /etc/network/interfaces`, appuyer sur **Entré** et entrer votre *mot de passe*
3. Identifier la ligne de code `iface lo inet loopback`
4. Supprimer toutes les ligne de code se trouvant après cette dernière
5. Configurer l'***addresse ip*** et la ***porte d'entré*** vers votre `gateway` :
  - `# The primary network interface`
   - `auto référence` (*remplacer `référence` par : `ens33` si vous êtes sur VMware et par `enp0s8` si vous êtes sur VirtualBox*)
   - `iface référence inet static` -> Permet de configurer une ***address ip static*** (*remplacer `référence` par : `ens33` si vous êtes sur VMware et par `enp0s8` si vous êtes sur VirtualBox*)
   - `address ip` -> Création de l'***address ip static*** : 
     - Si `Web`, remplacer `ip` par `192.168.0.5`
     - Si `Manager`, remplacer `ip` par `192.168.0.3`
   - `netmask 255.255.0.0` -> Configuration de l'identificateur
   - `gateway 192.168.0.2` -> Configuration de la *porte d'entré* vers votre `gateway`
7. Appuyer simultanément sur `Ctr + s`, puis `Ctr + x`
8. Entrer `sudo systemctl restart networking`, pour redémarrer le réseau de votre *VM*, appuyer sur **Entré**, puis entrer votre *mot de passe*
9. Pour vérifier si les changements ont bien été pris en comptent, vous allez devoir *ping* votre `gateway`, entrer `ping 192.168.0.2`, puis appuyer simultanement sur les touches `Ctr + c`
10. Si il y a autant de packages reçu que de packages transmit, c'est que tout c'est bien passé.
11. Pour vérifier que vos VMs sont bien connectées a Internet, via votre `gateway`, entrer `ping google.com`, puis appuyer simultanement sur les touches `Ctr + c`
12. Si il y a autant de packages reçu que de packages transmit, c'est que tout c'est bien passé.

#### Configuration de votre DHCP

Votre ***Dynamic Host Configuration Protocol***, ou **DHCP**, va permettre de configurer votre réseau. En effet, c'est ce dernier qui vas permettre de configurer les addresses ip destiné au utilisateur, ainsi que celles destiné aux VMs de Setup et bien d'autres choses.

##### Installation de DHCP

1. Ouvrir votre VM `manager`
2. Ecrir `sudo apt-get update`, appuyer sur **Entré** puis entrer votre *mot de passe*
3. Une fois la mise à jour finit, ecrir `sudo apt-get install isc-dhcp-server`, appuyer sur **Entré**

##### Configurer l'interface réseau pour le serveur DHCP

1. Ouvrir votre VM `manager`
2. Entrer `sudo nano /etc/default/isc-dhcp-server`, appuyer sur **Entré**
3. Identifier la ligne de code `INTERFACESv4=""`
4. Completer la ligne de code par `INTERFACESv4="référence"` -> interface réseau sur la qu'elle le serveur **DHCP** écoute (*remplacer `référence` par : `ens33` si vous êtes sur VMware et par `enp0s8` si vous êtes sur VirtualBox*)
5. Appuyer simultanément sur `Ctr + s`, puis `Ctr + x`

##### Configurer votre serveur DHCP

1. Ouvrir votre VM `manager`
2. Entrer `sudo nano /etc/dhcp/dhcpd.conf`, appuyer sur **Entré**
3. Identifier les lignes de codes suivantes et les commenter simplement en ajouter un `#` au debut de la ligne en question :
   - `option domain-name "exemple.org";`
   - `option domain-name-servers ns1.example.org, ns2.example.org;`
   - `default-lease-time 600;`
   - `max-lease-time 7200;`
   - `dns-update-style none;`
4. Identifier la ligne de code `# A slightly different configuration for an internal subnet`
5. Modifier le paragraphe de code qui le suit, pour le faire correspondre avec le paragraphe ci-dessous :
    - ```
        # A slightly different configuration for an internal ssubnet.
        subnet 192.168.0.0 netmask 255.255.0.0 {
            range 192.168.0.11 192.168.0.111;
            #  option domain-name-servers ns1.internal.example.org;
            #  option domain-name "internal.example.org";
            #  option routers 10.5.5.1;
            option broadcast-address 192.168.255.255;
            default-lease-time 86400;
            max-lease-time 172800;
        }
        ```
6. Pour vérifier si les changements ont bien été pris en comptent, entrer `sudo systemctl restart networking`, pour redémarrer le réseau de votre *VM*, appuyer sur **Entré**, puis entrer votre *mot de passe*
7. Si aucune erreurs ni textes rouge apparait, c'est parfait :)

[Ressource](https://youtu.be/TIxzBaoEZaQ)

#### Configuration de votre connection SSH

Comme dit précédement, votre `gateway` est le centre de votre réseau. En effet, seul votre `gateway` a accès aux autres VMs de votre réseau. Ainsi, Pour vous connecter a une de vos VMs de configurations (*`web` et `manager`*), vous devrez dans un premier temps vous connecter a votre `gateway` puis une fois connecté, refaire une connection ***ssh*** pour vos connecter à une des VMs de votre réseaux. Le problème étant que à chaque connection depuis votre `gateway`, vous allez devoir renseigner votre ***mot de passe***. J'ai la solution ;)

1. Ouvrir votre `gateway`
2. Entré `ssh-keygen` -> cette commande va générer une clé personnel unique
3. Vous allez maintenant devoir partager cette ***clé shh*** à vos 3 VMs de configuratins, pour cela entrer les commandes suivantes :
   - ***Web*** => `ssh-copy-id -i ~/.ssh/id_rsa.pub user@192.168.0.5` (*Remplacer `user`*)
   - ***Manager*** => `ssh-copy-id -i ~/.ssh/id_rsa.pub user@192.168.0.3` (*Remplacer `user`*)

[Ressource](https://www.ssh.com/ssh/copy-id)

##