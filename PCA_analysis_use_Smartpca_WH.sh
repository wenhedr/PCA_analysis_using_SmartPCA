# PCA analysis use Smartpca
# Wen He

# Step1:
# Smartpca download: https://alkesgroup.broadinstitute.org/EIGENSOFT/ 

# Step: get common SNPS
#plink bfile reference the .bed, .bim and.fam file
#need CASE.bed, .bim, and .fam
plink --bfile CASE --extract Pos_prune_only_1kg_intersect.txt --make-bed --out CASE.PCA
#need 1000G.bed, .bim, and .fam
plink --bfile 1000G --extract Pos_prune_only_1kg_intersect.txt --make-bed --out 1000G.PCA

##Step2: Run Smartpca 
##Create SmartPCA parameter 
##Convertf par file for CASE

genotypename:	CASE.PCA.bed
snpname:	CASE.PCA.bim
indivname:	CASE.PCA.fam
outputformat:	EIGENSTRAT
genotypeoutname:	CASE.PCA.geno
snpoutname:	CASE.PCA.snp
indivoutname:	CASE.PCA.ind
familynames:	YES

    #Saved as CASE_convertf.par

##Convertf par file for 1000G

genotypename:	1000G.PCA.bed
snpname:	1000G.PCA.bim
indivname:	1000G.PCA.fam
outputformat:	EIGENSTRAT
genotypeoutname:	1000G.PCA.geno
snpoutname:	1000G.PCA.snp
indivoutname:	1000G.PCA.ind
familynames:	YES

    #Saved as 1000G_convertf.par

##Run convertf 

convertf -p CASE_convertf.par

convertf -p 1000G_convertf.par

##Change ind identifiers

sed -i '' 's/-9/STUDY/g'      CASE.PCA.ind 
sed -i '' 's/???/STUDY/g'     CASE.PCA.ind 
sed -i '' 's/Control/STUDY/g' CASE.PCA.ind 
sed -i '' 's/control/STUDY/g' CASE.PCA.ind 
sed -i '' 's/CONTROL/STUDY/g' CASE.PCA.ind 
sed -i '' 's/Case/STUDY/g'    CASE.PCA.ind 
sed -i '' 's/case/STUDY/g'    CASE.PCA.ind 
sed -i '' 's/CASE/STUDY/g'    CASE.PCA.ind 


sed -i '' 's/-9/1000G/g'      1000G.PCA.ind 
sed -i '' 's/???/1000G/g'     1000G.PCA.ind 
sed -i '' 's/Control/1000G/g' 1000G.PCA.ind 
sed -i '' 's/control/1000G/g' 1000G.PCA.ind 
sed -i '' 's/CONTROL/1000G/g' 1000G.PCA.ind 
sed -i '' 's/Case/1000G/g'    1000G.PCA.ind 
sed -i '' 's/case/1000G/g'    1000G.PCA.ind
sed -i '' 's/CASE/1000G/g'    1000G.PCA.ind


##mergeit par file 

ind1: CASE.PCA.ind
geno1: CASE.PCA.geno
snp1: CASE.PCA.snp
ind2: 1000G.PCA.ind
geno2: 1000G.PCA.geno
snp2: 1000G.PCA.snp
indoutfilename: CASE_1000G.ind
snpoutfilename: CASE_1000G.snp
genooutfilename: CASE_1000G.geno
outputformat: EIGENSTRAT
strandcheck: NO

#Save as CASE_1000G.mergeit.par

#run mergeit 

mergeit -p CASE_1000G.mergeit.par


##SmartPCA par file 
# evec file:the position of each individual along eigenvectors
# evel file: the ordered eigenvalues corresponding to the eigenvectors

genotypename: CASE_1000G.geno
snpname: CASE_1000G.snp
indivname: CASE_1000G.ind
evecoutname: CASE_1000G.evec
evaloutname: CASE_1000G.eval
nsnpldregress: 2
snpweightoutname: CASE_1000G.SNPweight.txt
numoutlieriter: 0
numoutevec: 10
altnormstyle: NO
poplistname: 1000G
numthreads: 4

#save as CASE_1000G.smartPCA.par

##RUN SMARTPCA 

smartpca -p CASE_1000G.smartPCA.par 


CASE_1000G.smartPCA.par 


##Format evec file 

sed 's/:/    /g' CASE_1000G.evec > CASE_1000G.evecX

#Graph in R