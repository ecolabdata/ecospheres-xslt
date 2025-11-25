## Description

Supprime les balises vides.


## Paramètres

<div class="fr-table"><div class="fr-table__wrapper"><div class="fr-table__container"><div class="fr-table__content">

| Paramètre   | Requis | Défaut | Description |
|:------------|:-------|:-------|:------------|
| `safe-mode` | non    | "yes" | Si "yes", supprime uniquement les balises vides "sûres". Si "no", supprime **toutes** les balises vides. |

</div></div></div></div>


## Prérequis

Aucun.


## Motivation

Les balises vides (ni contenu, ni attributs) peuvent créer des problèmes tels que :
- Masquer d'autres balises dans les cas où seule la première occurrence d'une balise est prise en compte.
- Valider à tort des contraintes se basant uniquement sur la présence d'une balise sans vérifier le contenu attendu.
- Complexifier inutilement les fiches XML et dans certains cas afficher inutilement les champs équivalents dans les interfaces utilisateurs.

Supprimer les balises vides peut cependant être risqué dans certains cas :
- Le standard peut avoir attribué une sémantique à la simple présence d'une certaine balise, même vide.
- Les applicatifs exploitant le XML peuvent subit des effets de bords lorsque les balises vides sont supprimées, même si en théorie il n'est pas prévu que cela ait un impact.

Pour ces raisons, cette transformation ne s'applique qu'à certaines balises pour lesquelles nous avons jugé que la présence d'une balise vide est plus dommageable que sa suppression.

Actuellement, les balises suivantes sont supprimées lorsqu'elles sont vides :
- `//gmd:MD_DataIdentification//gmd:CI_Citation//gmd:MD_Identifier`

Cette liste pourra être complétée à mesure que nous identifions d'autres cas problèmatiques.


## Limites

Cette transformation fait l'hypothèse que l'occurrence vide d'une balise est sémantiquement équivalent à l'absence de cette balise.

Comme indiqué dans la section *Motivation*, il peut éventuellement exister des cas particuliers où cette hypothèse s'avère fausse. Il est donc important, surtout lorsque l'option `remove-all` est activée, de vérifier l'impact de cette transformation sur le catalogue cible, ou d'utiliser la transformation uniquement pour évaluer les problèmes, sans appliquer les modifications au catalogue cible.


## Exemples

```
<gmd:citation>
  <gmd:CI_Citation>
    <gmd:title>
      <gco:CharacterString>Titre de la fiche</gco:CharacterString>
    </gmd:title>
    ...
    <gmd:identifier>
      <gmd:MD_Identifier>
        <gmd:code>
          <gco:CharacterString></gco:CharacterString>
        </gmd:code>
      </gmd:MD_Identifier>
    </gmd:identifier>
    <gmd:identifier>
      <gmd:MD_Identifier>
        <gmd:code>
          <gco:CharacterString>https://www.example.com/moncatalogue/3374b038-d51a-49fa-98e5-6e68f6aff186</gco:CharacterString>
        </gmd:code>
      </gmd:MD_Identifier>
    </gmd:identifier>
  </gmd:CI_Citation>
</gmd:citation>
```

devient :

```
<gmd:citation>
  <gmd:CI_Citation>
    <gmd:title>
      <gco:CharacterString>Titre de la fiche</gco:CharacterString>
    </gmd:title>
    ...
    <!-- La première section <gmd:identifier> est supprimée car récursivement vide -->
    <gmd:identifier>
      <gmd:MD_Identifier>
        <gmd:code>
          <gco:CharacterString>https://www.example.com/moncatalogue/3374b038-d51a-49fa-98e5-6e68f6aff186</gco:CharacterString>
        </gmd:code>
      </gmd:MD_Identifier>
    </gmd:identifier>
  </gmd:CI_Citation>
</gmd:citation>
```

<br/>

**Avec l'option `remove-all` activée** :

<br/>

```
<gmd:extent>
  <gml:TimePeriod>
    <gml:beginPosition></gml:beginPosition>
    <gml:endPosition>2014-02-02</gml:endPosition>
  </gml:TimePeriod>
</gmd:extent>
```

devient :

```
<gmd:extent>
  <gml:TimePeriod>
    <gml:endPosition>2014-02-02</gml:endPosition>
  </gml:TimePeriod>
</gmd:extent>
```

<br/>


```
<gmd:distributionFormat>
  <gmd:MD_Format>
    <gmd:name gco:nilReason="missing">
      <gco:CharacterString />
    </gmd:name>
    <gmd:version gco:nilReason="unknown">
      <gco:CharacterString />
    </gmd:version>
  </gmd:MD_Format>
</gmd:distributionFormat>
```

devient :

```
<gmd:MD_Distribution>
  <gmd:distributionFormat>
    <gmd:MD_Format>
      <!-- Les balises sans contenu mais possédant des attributs sont préservées -->
      <gmd:name gco:nilReason="missing" />
      <gmd:version gco:nilReason="unknown" />
    </gmd:MD_Format>
  </gmd:distributionFormat>
</gmd:MD_Distribution>
```


## Références

https://github.com/ecolabdata/ecospheres-xslt/issues/24
