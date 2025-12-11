## Description

Ajoute les paramètres requis aux URLs de distributions de type OGC WFS/WMS/etc.


## Paramètres

<div class="fr-table"><div class="fr-table__wrapper"><div class="fr-table__container"><div class="fr-table__content">

| Paramètre           | Requis | Défaut     | Description |
|:--------------------|:-------|:-----------|:------------|
| `ogc-protocols`     | non    | "wfs, wms" | Liste de protocoles OGC à traiter. |
| `override-existing` | non    | "no"       | Si "yes" les paramètres existants sont écrasés, si "non" ils sont préservés. |

</div></div></div></div>


## Prérequis

Les distributions doivent contenir un élément `gmd:protocol`.


## Motivation

data.gouv.fr n'affiche que les distributions au sens DCAT dans l'onglet "Fichiers".
Les autres distributions au sens ISO sont actuellement ignorées.

Le convertisseur SEMICeu identifie une distribution (au sens ISO) comme distribution (au sens DCAT) uniquement dans les conditions suivantes :
- l'URL de la distribution contient "request=GetCapabilities", ou
- la distribution déclare une `gmd:function` de type "download, "offlineAccess" ou "order".

En attendant une éventuelle évolution de ces contraintes, les moyens de faire figurer un élément dans l'onglet "Fichiers" d'une fiche data.gouv.fr sont donc ceux imposés par la conversion SEMICeu.

Pour les distributions de type OGC WFS/WMS/etc., de nombreuses fiches INSPIRE peuvent répondre à ces contraintes simplement en corrigeant leur URL pour la faire pointer sur la requête "GetCapabilities" du service (voir INSPIRE TG sections [3.3.3](https://github.com/INSPIRE-MIF/technical-guidelines/blob/main/metadata/metadata-iso19139/metadata-iso19139.adoc#333-inspire-view-service-linking) à 3.3.5).

Pour d'autres types de distributions (par exemple ATOM) et certains cas particuliers, voir la transformation [distributions-ajout-function](distributions-ajout-function.md).


## Exemples

```
<gmd:CI_OnlineResource>
  <gmd:linkage>
    <gmd:URL>https://example.com/wfs</gmd:URL>
  </gmd:linkage>
  <gmd:protocol>
    <gco:CharacterString>OGC:WFS</gco:CharacterString>
  </gmd:protocol>
  ...
</gmd:CI_OnlineResource>
```

devient :

```
<gmd:CI_OnlineResource>
  <gmd:linkage>
    <gmd:URL>https://example.com/wfs?service=WFS&request=GetCapabilities</gmd:URL>
  </gmd:linkage>
  <gmd:protocol>
    <gco:CharacterString>OGC:WFS</gco:CharacterString>
  </gmd:protocol>
  ...
</gmd:CI_OnlineResource>
```


## Références

https://github.com/ecolabdata/ecospheres-xslt/issues/48

Merci à Fabrice Phung de [GéoBretagne](https://geobretagne.fr/) pour la première version du XSLT.
