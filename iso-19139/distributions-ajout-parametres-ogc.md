## Description

Ajoute les paramètres requis aux URLs de ressources en ligne de type OGC WFS/WMS/etc.


## Paramètres

<div class="fr-table"><div class="fr-table__wrapper"><div class="fr-table__container"><div class="fr-table__content">

| Paramètre           | Requis | Défaut     | Description |
|:--------------------|:-------|:-----------|:------------|
| `ogc-protocols`     | non    | "wfs, wms" | Liste de protocoles OGC à traiter. |
| `override-existing` | non    | "no"       | Si "yes" les paramètres existants sont écrasés, si "non" ils sont préservés. |

</div></div></div></div>


## Prérequis

Les ressources en ligne doivent contenir un élément `gmd:protocol`.


## Motivation

En ISO-19139, une *ressource en ligne* (`gmd:CI_OnlineResource`) permet d'accéder à la donnée ou à des informations complémentaires concernant la ressource. En DCAT, ces deux finalités sont représentées de manière différente :
- les accès à la donnée sont des *distributions* ;
- les informations complémentaires sont des *pages*.

Le convertisseur SEMICeu détermine la représentation DCAT selon l'heuristique suivante :
- Une ressource en ligne est convertie en *distribution* si :
  - soit son URL (`gmd:linkage`) contient "request=GetCapabilities" ;
  - soit sa fonction (`gmd:function`) est de type "download, "offlineAccess" ou "order".
- Tout le reste est représenté comme *page*.

Pour les ressources en ligne de type OGC WFS/WMS/etc., de nombreuses fiches INSPIRE peuvent répondre à ces contraintes simplement en corrigeant leur URL pour la faire pointer sur la requête "GetCapabilities" du service (voir INSPIRE TG sections [3.3.3](https://github.com/INSPIRE-MIF/technical-guidelines/blob/main/metadata/metadata-iso19139/metadata-iso19139.adoc#333-inspire-view-service-linking) à 3.3.5).

Pour d'autres types de ressources en ligne (par exemple ATOM) et certains cas particuliers, voir la transformation [distributions-ajout-function](distributions-ajout-function.md).


## Effets data.gouv.fr

Affichage de la ressource en ligne sous *Fichiers principaux* ou *API* (selon le type) dans l'onglet *Fichiers*.

Contexte : Pour les fiches moissonnées, seules les *distributions* (au sens DCAT) sont affichées dans l'onglet *Fichiers*. Les autres types de ressources en ligne sont actuellement ignorés.


## Exemples

    <gmd:CI_OnlineResource>
      <gmd:linkage>
        <gmd:URL>https://example.com/wfs</gmd:URL>
      </gmd:linkage>
      <gmd:protocol>
        <gco:CharacterString>OGC:WFS</gco:CharacterString>
      </gmd:protocol>
      ...
    </gmd:CI_OnlineResource>

devient :

    <gmd:CI_OnlineResource>
      <gmd:linkage>
        <gmd:URL>https://example.com/wfs?service=WFS&request=GetCapabilities</gmd:URL>
      </gmd:linkage>
      <gmd:protocol>
        <gco:CharacterString>OGC:WFS</gco:CharacterString>
      </gmd:protocol>
      ...
    </gmd:CI_OnlineResource>


## Références

https://github.com/ecolabdata/ecospheres-xslt/issues/48

Merci à Fabrice Phung de [GéoBretagne](https://geobretagne.fr/) pour la première version du XSLT.
