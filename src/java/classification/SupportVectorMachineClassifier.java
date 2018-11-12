/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package classification;

import java.util.Random;
import java.util.concurrent.locks.Lock;
import java.util.logging.Level;
import java.util.logging.Logger;
import weka.classifiers.Evaluation;
import weka.classifiers.functions.LibSVM;
import weka.core.FastVector;
import weka.core.Instances;
import weka.core.converters.ConverterUtils;

/**
 *
 * @author aurea
 */
public class SupportVectorMachineClassifier implements Classifier {

    Instances[] trainingSplits;
    Instances[] testingSplits;
    FastVector predictions;
    Lock lock = new java.util.concurrent.locks.ReentrantLock();

    @Override
    public String classify(String dataPath) {
        String resultClassifier = "Support Vector Machine \n\n";
        try {

            ConverterUtils.DataSource fonte = new ConverterUtils.DataSource(dataPath);
            Instances data = fonte.getDataSet();
            if (data.classIndex() == -1) {
                data.setClassIndex(data.numAttributes() - 1);
            }

            LibSVM libsvm = new LibSVM();
            libsvm.buildClassifier(data);

            Evaluation crossVal;
            crossVal = new Evaluation(data);
            crossVal.crossValidateModel(libsvm, data, 10, new Random(1));
            resultClassifier += crossVal.toSummaryString();
            resultClassifier += "\n";

            resultClassifier += crossVal.toClassDetailsString();
            resultClassifier += "\n";
            String confMatrix = crossVal.toMatrixString().toString();
            /*String confMatrix = "=== Confusion Matrix ===\n";
            confMatrix += "\n";
            confMatrix += "      ";
            double[][] confusionMatrix = crossVal.confusionMatrix();
            for (int c = 0; c < confusionMatrix.length; c++) {
                confMatrix += (c * 1.0) + " ";
            }
            confMatrix += "\n";

            for (int i = 0; i < confusionMatrix.length; i++) {
                confMatrix += (i * 1.0) + " ";
                for (int j = 0; j < confusionMatrix[i].length; j++) {
                    confMatrix += confusionMatrix[i][j] + " ";
                }
                confMatrix += "\n";
            }*/

            resultClassifier += confMatrix;

        } catch (Exception ex) {
            Logger.getLogger(SupportVectorMachineClassifier.class.getName()).log(Level.SEVERE, null, ex);
        }
        return resultClassifier;
    }
    
     @Override
    public String classify(Instances data) {
        String resultClassifier = "Support Vector Machine \n\n";
        try {
            if (data.classIndex() == -1) {
                data.setClassIndex(data.numAttributes() - 1);
            }

            LibSVM libsvm = new LibSVM();
            libsvm.buildClassifier(data);

            Evaluation crossVal;
            crossVal = new Evaluation(data);
            crossVal.crossValidateModel(libsvm, data, 10, new Random(1));
            resultClassifier += crossVal.toSummaryString();
            resultClassifier += "\n";

            resultClassifier += crossVal.toClassDetailsString();
            resultClassifier += "\n";
            
             String confMatrix = crossVal.toMatrixString().toString();
             
             /*
            String confMatrix = "=== Confusion Matrix ===\n";
            confMatrix += "\n";
            confMatrix += "      ";
            double[][] confusionMatrix = crossVal.confusionMatrix();
            for (int c = 0; c < confusionMatrix.length; c++) {
                confMatrix += (c * 1.0) + " ";
            }
            confMatrix += "\n";

            for (int i = 0; i < confusionMatrix.length; i++) {
                confMatrix += (i * 1.0) + " ";
                for (int j = 0; j < confusionMatrix[i].length; j++) {
                    confMatrix += confusionMatrix[i][j] + " ";
                }
                confMatrix += "\n";
            }*/

            resultClassifier += confMatrix;

        } catch (Exception ex) {
            Logger.getLogger(SupportVectorMachineClassifier.class.getName()).log(Level.SEVERE, null, ex);
        }
        return resultClassifier;
    }

    @Override
    public Instances[][] crossValidationSplit(Instances data, int numberOfFolds
    ) {
        Instances[][] split = new Instances[2][numberOfFolds];
        for (int i = 0; i < numberOfFolds; i++) {
            split[0][i] = data.trainCV(numberOfFolds, i);
            split[1][i] = data.testCV(numberOfFolds, i);
        }
        return split;
    }

    @Override
    public Evaluation classifyEvaluation(Instances trainingSet, Instances testingSet) {
        Evaluation evaluation = null;
        try {
            evaluation = new Evaluation(trainingSet);
            LibSVM libSVM = new LibSVM();
            libSVM.buildClassifier(trainingSet);
            evaluation.evaluateModel(libSVM, testingSet);

        } catch (Exception ex) {

        }
        return evaluation;

    }

    @Override
    public double resultClassify(Instances data) {
         double accuracy =0.0;
        try {
            if (data.classIndex() == -1) {
                data.setClassIndex(data.numAttributes() - 1);
            }

            LibSVM libsvm = new LibSVM();
            libsvm.buildClassifier(data);

            Evaluation crossVal;
            crossVal = new Evaluation(data);
            crossVal.crossValidateModel(libsvm, data, 10, new Random(1));
            

            accuracy = crossVal.pctCorrect();

        } catch (Exception ex) {
            Logger.getLogger(SupportVectorMachineClassifier.class.getName()).log(Level.SEVERE, null, ex);
        }
        return accuracy;
    }

}
