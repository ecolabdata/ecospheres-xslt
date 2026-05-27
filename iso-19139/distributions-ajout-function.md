## Description

Ajoute un élément de type `gmd:function` à une ressource en ligne.


## Paramètres

<div class="fr-table"><div class="fr-table__wrapper"><div class="fr-table__container"><div class="fr-table__content">

| Paramètre           | Requis | Défaut     | Description |
|:--------------------|:-------|:-----------|:------------|
| `match-field`       | oui    | \<aucun>   | Champ dans lequel rechercher `match-string`, parmi : <ul><li>"name" : Recherche dans `gmd:name/gco:CharacterString`.</li><li>"url" : recherche dans `gmd:linkage/gmd:URL` ;</li><li>"protocol" : recherche (textuelle) dans `gmd:protocol/*`.</li></ul> |
| `match-string`      | oui    | \<aucun>   | Chaîne de caractères à rechercher dans `match-field`. |
| `function-type`     | non    | "download" | Type de `gmd:function` à ajouter à la distribution, parmi "download", "offlineAccess", "order". |
| `override-existing` | non    | "no"       | Si "no", seules les ressources en ligne ne contenant pas de `gmd:function` sont prises en compte.<br/>Si "yes", les ressources en ligne contenant déjà un `gmd:function` sont également prises en compte, et le `gmd:function` existant sera remplacé. |

</div></div></div></div>


## Prérequis

Aucun.


## Motivation

En ISO-19139, une *ressource en ligne* (`gmd:CI_OnlineResource`) permet d'accéder à la donnée ou à des informations complémentaires concernant la ressource. En DCAT, ces deux finalités sont représentées de manière différente :
- les accès à la donnée sont des *distributions* ;
- les informations complémentaires sont des *pages*.

Le convertisseur SEMICeu détermine la représentation DCAT selon l'heuristique suivante :
- Une ressource en ligne est convertie en *distribution* si :
  - soit son URL (`gmd:linkage`) contient "request=GetCapabilities" ;
  - soit sa fonction (`gmd:function`) est de type "download, "offlineAccess" ou "order".
- Tout le reste est représenté comme *page*.

Pour les ressources en ligne de type OGC WFS/WMS/..., de nombreuses fiches INSPIRE peuvent répondre à ces contraintes simplement en corrigeant leur URL pour la faire pointer sur la requête "GetCapabilities" du service (voir la transformation [distributions-ajout-parametres-ogc](distributions-ajout-parametres-ogc.md).

Cependant, pour d'autres types de ressources en ligne (par exemple ATOM) et certains cas particuliers, il est nécessaire d'ajouter `gmd:function` de type "download".




## Limites

Seule la recherche par chaîne de caractères *exacte* est possible avec le paramètre `match-string`.

Attention à utiliser des chaîne de caractères suffisamment précises pour éviter les faux positifs.


## Exemples

    <gmd:CI_OnlineResource>
      <gmd:linkage>
        <gmd:URL>http://atom.geo-ide.developpement-durable.gouv.fr/atomArchive/GetResource?id=...</gmd:URL>
      </gmd:linkage>
      <gmd:name>
        <gco:CharacterString>Téléchargement simple (Atom) du jeu et des documents associés via internet</gco:CharacterString>
      </gmd:name>
    </gmd:CI_OnlineResource>

devient :

    <gmd:CI_OnlineResource>
      <gmd:linkage>
        <gmd:URL>http://atom.geo-ide.developpement-durable.gouv.fr/atomArchive/GetResource?id=...</gmd:URL>
      </gmd:linkage>
      <gmd:name>
        <gco:CharacterString>Téléchargement simple (Atom) du jeu et des documents associés via internet</gco:CharacterString>
      </gmd:name>
      <gmd:function>
        <gmd:CI_OnLineFunctionCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#CI_OnLineFunctionCode" codeListValue="download"/>
      </gmd:function>
    </gmd:CI_OnlineResource>

Ce résultat peut etre obtenu avec les recherches suivantes (entre autres) :
- `match-field` = "name" / `match-string` : "Téléchargement simple (Atom)" ;
- `match-field` = "url" / `match-string` : "atom.geo-ide.developpement-durable.gouv.fr/atomArchive/GetResource".

Exemples courants de recherches dans le champ "name" :
- "Accès au lien ATOM de téléchargement" ;
- "Accès au téléchargement des données" ;
- "Téléchargement direct des données" ;
- "Téléchargement simple (Atom)" ;
- "Télécharger les données".

Les recherches sur le champ "url" dépendront généralement de la plateforme utilisée par votre catalogue.


## Références

https://github.com/ecolabdata/ecospheres/wiki/Recommandations-ISO-DCAT#rendre-les-distributions-identifiables

