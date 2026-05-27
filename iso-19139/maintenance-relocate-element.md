## Description

Déplace les informations de maintenance.


## Paramètres

Aucun.


## Prérequis

Aucun.


## Motivation

ISO-19139 définit deux emplacements permettant de renseigner des informations de maintenance :
1. `/gmd:MD_Metadata/gmd:metadataMaintenance` ;
2. `/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceMaintenance`.

Ces deux emplacements n'ont pas la même sémantique (*metadata* vs *ressource*), mais :
- le Guide du CNIG n'aborde pas ces métadonnées ;
- les Technical guidelines INSPIRE ne font référence qu'au [deuxième emplacement](https://github.com/INSPIRE-MIF/technical-guidelines/blob/main/metadata/metadata-iso19139/metadata-iso19139.adoc#c71-maintenance-information) ;
- le convertisseur SEMICeu ne prend en charge que le deuxième emplacement.

Nous constatons en pratique que certains catalogues utilisent le premier emplacement plutôt que le deuxième, sans faire de distinction sémantique. Dans ces cas, il convient de déplacer les informations de maintenance à l'endroit attendu par le convertisseur SEMICeu pour ne pas perdre les métadonnées.


## Effets data.gouv.fr

Présence de l'information dans l'onglet *Informations*, section *Extras*, clé "provenance".

Sur ecologie.data.gouv.fr, affichage de la *Généalogie* dans l'onglet *Informations*.


## Limites

### Applicabilité

Cette transformation fait l'hypothèse d'une équivalence sémantique entre les deux emplacements définis par le standard ISO-19139. Cette hypothèse est fausse en général, mais elle peut s'avérer pertinente dans le contexte INSPIRE, qui ne mentionne qu'un seul emplacement.

**L'administrateur de catalogue doit donc impérativement s'assurer que l'hypothèse s'applique à son catalogue avant d'utiliser cette transformation.**


### Validation

Cette transformation ne respecte pas la condition d'ordre imposée par le schéma XSL ISO-19139, plaçant systématiquement l'élément `gmd:resourceMaintenance` en dernier dans `gmd:MD_DataIdentification`.

En pratique cela n'a pas d'impact sur GéoNetwork, mais une validation étendue du schéma peut éventuellement échouer pour cette raison. Dans ce cas, il suffit de re-sauvegarder la fiche depuis GéoNetwork pour que les éléments soient automatiquement réorganisés.


## Exemples

    <gmd:MD_Metadata ...>
      <gmd:identificationInfo>
        <gmd:MD_DataIdentification>
          ...
        </gmd:MD_DataIdentification>
      </gmd:identificationInfo>
      <gmd:metadataMaintenance>
        <gmd:MD_MaintenanceInformation>
          <gmd:maintenanceAndUpdateFrequency>
            <gmd:MD_MaintenanceFrequencyCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_MaintenanceFrequencyCode" codeListValue="annual"/>
          </gmd:maintenanceAndUpdateFrequency>
        </gmd:MD_MaintenanceInformation>
      </gmd:metadataMaintenance>
    </gmd:MD_Metadata>

devient :

    <gmd:MD_Metadata ...>
      <gmd:identificationInfo>
        <gmd:MD_DataIdentification>
          ...
          <gmd:resourceMaintenance>
            <gmd:MD_MaintenanceInformation>
              <gmd:maintenanceAndUpdateFrequency>
                <gmd:MD_MaintenanceFrequencyCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_MaintenanceFrequencyCode" codeListValue="annual"/>
              </gmd:maintenanceAndUpdateFrequency>
            </gmd:MD_MaintenanceInformation>
          </gmd:resourceMaintenance>
        </gmd:MD_DataIdentification>
      </gmd:identificationInfo>
    </gmd:MD_Metadata>


## Références

https://github.com/ecolabdata/ecospheres/issues/868
