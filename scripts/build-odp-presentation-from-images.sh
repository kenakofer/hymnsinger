#!/bin/bash

## Create the odp presentation
BASE=$1
OUTPUT_DIR="docs/local-lilypond-outputs/"
SKELETON_DIR="scripts/odp-skeleton"
TEMP_DIR="/tmp/lilypond-odp-build"
PICTURES_DIR="$TEMP_DIR/Pictures"

MANIFEST_ENTRY_TEMPLATE='<manifest:file-entry manifest:full-path="FILE_NAME" manifest:media-type="image/png"/>'
MANIFEST_FOOTER='</manifest:manifest>'

CONTENT_SLIDE_TEMPLATE='<draw:page draw:name="pageIMAGE_NUMBER" draw:style-name="dp1" draw:master-page-name="Default" presentation:presentation-page-layout-name="AL1T0"><draw:frame draw:style-name="gr1" draw:text-style-name="P1" draw:layer="layout" svg:width="27.933cm" svg:height="15.711cm" svg:x="0.007cm" svg:y="0cm"><draw:image xlink:href="FILE_NAME" xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad" draw:mime-type="image/png"><text:p/></draw:image></draw:frame><presentation:notes draw:style-name="dp1"><draw:page-thumbnail draw:style-name="gr2" draw:layer="layout" svg:width="18.624cm" svg:height="10.476cm" svg:x="1.482cm" svg:y="2.123cm" draw:page-number="IMAGE_NUMBER" presentation:class="page"/><draw:frame presentation:style-name="pr1" draw:text-style-name="P2" draw:layer="layout" svg:width="17.271cm" svg:height="12.572cm" svg:x="2.159cm" svg:y="13.271cm" presentation:class="notes" presentation:placeholder="true"><draw:text-box/></draw:frame></presentation:notes></draw:page>'
CONTENT_FOOTER='<presentation:settings presentation:mouse-visible="false"/></office:presentation></office:body></office:document-content>'

# Remove anything that already exists in the TEMP directory
rm  -fr "$TEMP_DIR"
# Copy the unzipped odp skeleton into temp directory
cp -r $SKELETON_DIR $TEMP_DIR
# Move all this song's slides images into the temp/Pictures
mkdir $PICTURES_DIR

# For each file in the source:
for image_number in {1..100}; do
    source_file_name="$OUTPUT_DIR$BASE-slides-page$image_number.png"

    # Break if this file doesn't exist (we have finished doing all the files)
    [ ! -f "$source_file_name" ] && break

    # Copy the file into the ODP pictures directory
    dest_file_name="$PICTURES_DIR/$BASE-slides-page$image_number.png"
    #cp "$source_file_name" "$dest_file_name"
    mv "$source_file_name" "$dest_file_name"

    # Append slide skeleton to content.xml, replacing IMAGE_NUMBER and FILE_NAME path
    relative_file_name="Pictures/$BASE-slides-page$image_number.png"
    echo $CONTENT_SLIDE_TEMPLATE | sed "s/IMAGE_NUMBER/$image_number/g" | sed "s|FILE_NAME|$relative_file_name|g" >> $TEMP_DIR/content.xml
    echo $MANIFEST_ENTRY_TEMPLATE | sed "s|FILE_NAME|$relative_file_name|g" >> $TEMP_DIR/META-INF/manifest.xml
done

# Append footer to content.xml, making this a complete and valid xml file
echo $CONTENT_FOOTER >> $TEMP_DIR/content.xml
echo $MANIFEST_FOOTER >> $TEMP_DIR/META-INF/manifest.xml

# zip up the temp dir into $BASE.odp
cd $TEMP_DIR
zip -q0 "$BASE.odp" mimetype # The mimetype must be stored first, with 0 compression
zip -qru "$BASE.odp" *
cd - > /dev/null
mv "$TEMP_DIR/$BASE.odp" $OUTPUT_DIR