#!/bin/bash

AWSBIN=/usr/local/bin/aws
STACKNAME="tp2gbstack"
TPL="tpl.yaml"
echo ""
echo "Nom de la stack utilisé: $STACKNAME"
echo ""
echo "Choisir une action de stack 1,2,3 ou 4."
echo ""
CHOIX=("CREATE" "UPDATE" "DELETE" "EXIT")

#RAZ trace.log
echo "" > trace.log

select var in "${CHOIX[@]}"; do
    case $var in
        "CREATE")
            echo "------START CREATE STACK-------" 1>>trace.log 2>&1
            read -p "Saisir le type d'instance ex=> t2.micro : " n1
            if [ "$n1" = "t2.micro" ]; then
                echo "Le type d'instance est $n1"
            elif [ "$n1" != "t2.micro" ]; then
                echo "Le type d'instance est $n1"
                read -p "Confimer l'instance $q1 avec y/n ."
                if [ "$q1" = "y" ]; then
                    echo "instance utilisé $n1"
                elif [ "$q1" = "n" ]; then
                    read -p "Saisir le type d'instance ex=> t2.micro : " n1
                    if [ "$n1" = "t2.micro" ]; then
                        echo "Le type d'instance est $n1"
                    elif [ "$n1" != "t2.micro" ]; then
                        echo "Verifier les instances possible"
                        exit
                    fi
                fi
            fi
            read -p "Saisir le nom du bucket qui sera prefixé de 'learn-cloudformation-gbtp2-' : " n2
            BKTNAME="learn-cloudformation-gbtp2-$n2"
            echo "Nom du bucket utilisé: $BKTNAME"
            read -p "Confimer le nom bucket à utilisé $BKTNAME avec y/n ." q2
            if [ "$q2" = "y" ]; then
                echo "Bucket utilisé $BKTNAME"
            elif [ "$q2" = "n" ]; then
                read -p "Saisir le nom du bucket qui sera prefixé de 'learn-cloudformation-gbtp2-' : " n2
                BKTNAME="learn-cloudformation-gbtp2-$n2"
                echo "Le nom du bucket est $BKTNAME"
            fi

            RETCREAT1=$($AWSBIN cloudformation create-stack --template-body file://$TPL --stack-name $STACKNAME --parameters  ParameterKey=InstanceType,ParameterValue=$n1 ParameterKey=S3ParamBucket,ParameterValue=$BKTNAME)
            RETCREAT2=$($AWSBIN cloudformation wait stack-create-complete --stack-name $STACKNAME)
            RETCREAT3=$($AWSBIN cloudformation describe-stacks --stack-name $STACKNAME)
            echo "==>RETOUR CREATE STACK<==" 1>>trace.log 2>&1
            echo $RETCREAT1 1>>trace.log 2>&1
            echo "==>RETOUR CREATE WAIT STACK<==" 1>>trace.log 2>&1
            echo $RETCREAT2 1>>trace.log 2>&1
            echo "==>RETOUR describe-stacks STACK<==" 1>>trace.log 2>&1
            echo $RETCREAT3 1>>trace.log 2>&1
            echo "------END CREATE STACK-------" 1>>trace.log 2>&1
            ;;
        "UPDATE")
            echo "------START UPDATE STACK-------" 1>>trace.log 2>&1
            RETUPT1=$($AWSBIN cloudformation update-stack --template-body file://$TPL --stack-name $STACKNAME)
            RETUPT2=$($AWSBIN cloudformation cloudformation wait stack-update-complete --stack-name $STACKNAME)
            RETUPT3=$($AWSBIN cloudformation describe-stacks --stack-name $STACKNAME)
            echo "==>RETOUR UPDATE STACK<==" 1>>trace.log 2>&1
            echo $RETUPT1 1>>trace.log 2>&1
            echo "==>RETOUR UPDATE WAIT STACK<==" 1>>trace.log 2>&1
            echo $RETUPT2 1>>trace.log 2>&1
            echo "==>RETOUR UPDATE WAIT STACK<==" 1>>trace.log 2>&1
            echo $RETUPT3 1>>trace.log 2>&1
            echo "------END UPDATE STACK-------" 1>>trace.log 2>&1
            ;;
        "DELETE")
            echo "------START DELETE STACK-------" 1>>trace.log 2>&1
            RETDEL1=$($AWSBIN cloudformation delete-stack --stack-name $STACKNAME)
            echo $RETDEL1 1>>trace.log 2>&1
            echo "------END DELETE STACK-------" 1>>trace.log 2>&1
            ;;
        "EXIT")
            echo "EXIT" 1>>trace.log 2>&1
            exit
            ;;
        *)
            echo "CHOIX NON VALIDE"
            ;;
    esac
done