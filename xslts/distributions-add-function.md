## Description

Ajoute un élément de type `gmd:function` à une distribution.


## Paramètres

<div class="fr-table"><div class="fr-table__wrapper"><div class="fr-table__container"><div class="fr-table__content">

| Paramètre           | Requis | Défaut     | Description |
|:--------------------|:-------|:-----------|:------------|
| `match-string`      | oui    | \<aucun>   | Chaîne de caractères à rechercher dans `match-field`. |
| `match-field`       | oui    | "name"     | Champ dans lequel rechercher `match-string`, parmi : <ul><li>"name" : Recherche dans `gmd:name/gco:CharacterString`.</li><li>"url" : Recherche dans `gmd:linkage/gmd:URL`.</li></ul> |
| `function-type`     | oui    | "download" | Type de `gmd:function` à ajouter à la distribution, parmi "download", "offlineAccess", "order". |
| `override-existing` | oui    | "no"       | Si "no", seules les distributions ne contenant pas de `gmd:function` sont prises en compte.<br/>Si "yes", les distributions contenant déjà un `gmd:function` sont également prises en compte, et un `gmd:function` existant sera remplacé. |

</div></div></div></div>


## Prérequis

Aucun.


## Motivation

data.gouv.fr n'affiche que les distributions au sens DCAT dans l'onglet "Fichiers".
Les autres distributions au sens ISO sont actuellement ignorées.

Le convertisseur SEMICeu identifie une distribution (au sens ISO) comme distribution (au sens DCAT) uniquement dans les conditions suivantes : 
- l'URL de la distribution contient "request=GetCapabilities", ou
- la distribution déclare une `gmd:function` de type "download, "offlineAccess" ou "order".

En attendant une éventuelle évolution de ces contraintes, les moyens de faire figurer un élément dans l'onglet "Fichiers" d'une fiche data.gouv.fr sont donc ceux imposés par la conversion SEMICeu.

Pour les services de types WFS/WMS/WMTS, de nombreuses fiches INSPIRE peuvent répondre à ces contraintes simplement en corrigeant l'URL des distributions, qui devraient pointer sur le "GetCapabilities" du service et donc contenir "request=GetCapabilities".
Cependant, pour d'autres types de services (par exemple ATOM) et certains cas particuliers, il est nécessaire d'ajouter un `gmd:function` de type "download".


## Limites

Seule la recherche par chaîne de caractères *exacte* est possible actuellement.

Attention à utiliser des chaîne de caractères suffisamment précises pour éviter les faux positifs.


## Exemples

```
<gmd:CI_OnlineResource>
  <gmd:linkage>
    <gmd:URL>http://atom.geo-ide.developpement-durable.gouv.fr/atomArchive/GetResource?id=...</gmd:URL>
  </gmd:linkage>
  <gmd:name>
    <gco:CharacterString>Téléchargement simple (Atom) du jeu et des documents associés via internet</gco:CharacterString>
  </gmd:name>
</gmd:CI_OnlineResource>
```

devient :

```
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
```

Ce résultat peut etre obtenu avec les recherches suivantes (entre autres) : 
- `match-field` = "name" / `match-string` : "Téléchargement simple (Atom)".
- `match-field` = "url" / `match-string` : "atom.geo-ide.developpement-durable.gouv.fr/atomArchive/GetResource"

Exemples courants de recherches dans le champ "name" :
- "Accès au lien ATOM de téléchargement"
- "Accès au téléchargement des données"
- "Téléchargement direct des données"
- "Téléchargement simple (Atom)"
- "Télécharger les données"

Les recherches sur le champ "url" dépendront généralement de la plateforme utilisée par votre catalogue.


## Références

https://github.com/ecolabdata/ecospheres/wiki/Recommandations-ISO-DCAT#rendre-les-distributions-identifiables

