# Create dbNSFP3 hg19 VCF file
#
# Convert a directory of dbNSFP3 variant annotation files into a 
# single VCF file (with .tbi index file). Output will be written
# in the present working directory.
#
# Example usage:
#   ./create_dbNSFP3_hg19_VCF.sh /path/to/dbNSFP3.x/

DBNSFP_DIR=$(echo "$1" | sed 's/\/*$//') # e.g. /path/to/dbNSFP3.0 (all trailing slashes will be removed)
SOURCE=$(echo "$DBNSFP_DIR" | sed 's/.*\///g') # e.g dbNSFP3.0

echo "- Combining all variant files from $DBNSFP_DIR into $SOURCE.txt..."
cat <(head -1 $DBNSFP_DIR/*_variant.chr1 | sed 's/#//') \
    <(tail -qn +2 $DBNSFP_DIR/*_variant.chr1 \
                  $DBNSFP_DIR/*_variant.chr2 \
                  $DBNSFP_DIR/*_variant.chr3 \
                  $DBNSFP_DIR/*_variant.chr4 \
                  $DBNSFP_DIR/*_variant.chr5 \
                  $DBNSFP_DIR/*_variant.chr6 \
                  $DBNSFP_DIR/*_variant.chr7 \
                  $DBNSFP_DIR/*_variant.chr8 \
                  $DBNSFP_DIR/*_variant.chr9 \
                  $DBNSFP_DIR/*_variant.chr10 \
                  $DBNSFP_DIR/*_variant.chr11 \
                  $DBNSFP_DIR/*_variant.chr12 \
                  $DBNSFP_DIR/*_variant.chr13 \
                  $DBNSFP_DIR/*_variant.chr14 \
                  $DBNSFP_DIR/*_variant.chr15 \
                  $DBNSFP_DIR/*_variant.chr16 \
                  $DBNSFP_DIR/*_variant.chr17 \
                  $DBNSFP_DIR/*_variant.chr18 \
                  $DBNSFP_DIR/*_variant.chr19 \
                  $DBNSFP_DIR/*_variant.chr20 \
                  $DBNSFP_DIR/*_variant.chr21 \
                  $DBNSFP_DIR/*_variant.chr22 \
                  $DBNSFP_DIR/*_variant.chrX \
                  $DBNSFP_DIR/*_variant.chrY \
                  $DBNSFP_DIR/*_variant.chrM) \
                  > $SOURCE.txt
echo "   \--> Done! $SOURCE.vcf has been created"

echo "- Creating VCF file ($SOURCE.vcf)..."
tab2vcf --chr 8 \
        --pos 9 \
        --ref 3 \
        --alt 4 \
        --source $SOURCE \
        --reference hg19 \
        <(head -10 $SOURCE.txt) \
        | vcf-sort -c \
        1> $SOURCE.vcf 2> /dev/null
echo "   \--> Done! $SOURCE.vcf has been created"

echo "- Removing $SOURCE.txt..."
rm $SOURCE.txt
echo "   \--> Done! $SOURCE.txt has been removed"

echo "- Compressing $SOURCE.vcf..."
bgzip -f $SOURCE.vcf
echo "   \--> Done! $SOURCE.vcf.gz has been created"

echo "- Creating index file for $SOURCE.vcf.gz..."
bcftools index --tbi --force $SOURCE.vcf.gz
echo "   \--> Done! $SOURCE.vcf.gz.tbi has been created"

echo "- Final output written to:"
echo "  * $SOURCE.bcf.gz"
echo "  * $SOURCE.bcf.gz.tbi"
