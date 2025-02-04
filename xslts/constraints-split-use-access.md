## Description

Sépare les conditions d'utilisation des conditions d'accès.


## Paramètres

Aucun.


## Motivation

Lorsqu'un élément `gmd:resourceConstraints` contient à la fois un élément `gmd:accessConstraints` et un élément `gmd:useConstraints`, tous les éléments `gmd:otherConstraints` également présents vont être doublonnés en condition d'utilisation *et* en condition d'accès par le convertisseur SEMICeu ISO-19139 vers GeoDCAT-AP.

Un tel cas ne respectant pas le standard INSPIRE, il est difficile motiver une évolution du convertisseur SEMICeu.


## Limitations

La transformation prend en charge uniquement les cas pour lesquels la séparation des conditions d'utilisation et d'accès :
- améliore la prise en charge des métadonnées par data.gouv.fr ;
- n'est pas ambigue, ou peut être désambiguïsée de manière relativement fiable ;
- n'affecte pas significativement l'interprétation de cette section dans le catalogue d'origine.

Les autres cas pourront faire l'objet de futures améliorations, ou devront être traités manuellement.

La mise en conformité générale avec le standard INSPIRE ne fait pas partie des objectifs.


## Exemples

```
<gmd:resourceConstraints>
  <gmd:MD_LegalConstraints>
    <gmd:useLimitation>
       <gco:CharacterString>Licence Ouverte / Open Licence Version 2.0  https://www.etalab.gouv.fr/wp-content/uploads/2017/04/ETALAB-Licence-Ouverte-v2.0.pdf</gco:CharacterString>
    </gmd:useLimitation>
    <gmd:useLimitation>
      <gco:CharacterString>Aucun des articles de la loi ne peut être invoqué pour justifier d'une restriction d'accès public.</gco:CharacterString>
    </gmd:useLimitation>
    <gmd:accessConstraints>
      <gmd:MD_RestrictionCode codeListValue="otherRestrictions" codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode"/>
    </gmd:accessConstraints>
    <gmd:useConstraints>
      <gmd:MD_RestrictionCode codeListValue="license" codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode"/>
    </gmd:useConstraints>
    <gmd:otherConstraints>
      <gco:CharacterString>Pas de restriction d'accès public selon INSPIRE</gco:CharacterString>
    </gmd:otherConstraints>
  </gmd:MD_LegalConstraints>
</gmd:resourceConstraints>
```

devient :

```
<gmd:resourceConstraints>
  <gmd:MD_LegalConstraints>
    <gmd:accessConstraints>
      <gmd:MD_RestrictionCode codeListValue="otherRestrictions" codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode"/>
    </gmd:accessConstraints>
    <gmd:otherConstraints>
      <gco:CharacterString>Pas de restriction d'accès public selon INSPIRE</gco:CharacterString>
    </gmd:otherConstraints>
  </gmd:MD_LegalConstraints>
</gmd:resourceConstraints>
<gmd:resourceConstraints>
  <gmd:MD_LegalConstraints>
    <gmd:useLimitation>
      <gco:CharacterString>Licence Ouverte / Open Licence Version 2.0  https://www.etalab.gouv.fr/wp-content/uploads/2017/04/ETALAB-Licence-Ouverte-v2.0.pdf</gco:CharacterString>
    </gmd:useLimitation>
    <gmd:useLimitation>
      <gco:CharacterString>Aucun des articles de la loi ne peut être invoqué pour justifier d'une restriction d'accès public.</gco:CharacterString>
    </gmd:useLimitation>
    <gmd:useConstraints>
      <gmd:MD_RestrictionCode codeListValue="license" codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode"/>
    </gmd:useConstraints>
  </gmd:MD_LegalConstraints>
</gmd:resourceConstraints>
```

## Références

https://github.com/ecolabdata/ecospheres/wiki/Recommandations-ISO-DCAT#s%C3%A9parer-la-licence-des-conditions-dacc%C3%A8s
