% Charger les données Iris depuis un fichier CSV
% Assurez-vous que le fichier 'iris.csv' est dans le répertoire de travail d'Octave
data =dlmread('C:/Users/ASUS/Desktop/iris_octave.csv', '');

% Séparation des données en 80% pour l'entraînement et 20% pour le test
num_rows = size(data, 1);
num_train = round(0.8 * num_rows);  % 80% pour l'entraînement

% Mélanger les données aléatoirement pour une meilleure répartition
rand_indices = randperm(num_rows);
trainData = data(rand_indices(1:num_train), :);  % Données d'entraînement
testData = data(rand_indices(num_train+1:end), :);  % Données de test

% Fixer la valeur de k (nombre de voisins proches)
k = 3;

% Prédictions pour tous les échantillons du test set
predictions = zeros(size(testData, 1), 1);

% Boucle sur chaque échantillon de test pour trouver ses k plus proches voisins
for i = 1:size(testData, 1)
    % Calculer la distance euclidienne entre l'échantillon de test et tous les échantillons d'entraînement
    distances = sqrt(sum((trainData(:, 1:4) - testData(i, 1:4)).^2, 2));  % Colonnes 1 à 4 sont les caractéristiques
    
    % Trier les distances et trouver les indices des k plus proches voisins
    [~, sorted_indices] = sort(distances);
    nearest_neighbors = trainData(sorted_indices(1:k), 5);  % Colonnes 5 contient les labels de classe
    
    % Prédire la classe majoritaire parmi les k plus proches voisins
    predictions(i) = mode(nearest_neighbors);
end

% Calcul de l'accuracy
accuracy = sum(predictions == testData(:, 5)) / length(testData) * 100;
fprintf('Accuracy: %.2f%%\n', accuracy);

% Calcul des métriques de précision, rappel et F1-score
unique_labels = unique(testData(:, 5));
precision = 0;
recall = 0;
f1_score = 0;

for i = 1:length(unique_labels)
    true_positives = sum((predictions == unique_labels(i)) & (testData(:, 5) == unique_labels(i)));
    false_positives = sum((predictions == unique_labels(i)) & (testData(:, 5) ~= unique_labels(i)));
    false_negatives = sum((predictions ~= unique_labels(i)) & (testData(:, 5) == unique_labels(i)));
    
    % Précision (Precision)
    if (true_positives + false_positives) == 0
        precision_i = 0;
    else
        precision_i = true_positives / (true_positives + false_positives);
    end
    
    % Rappel (Recall)
    if (true_positives + false_negatives) == 0
        recall_i = 0;
    else
        recall_i = true_positives / (true_positives + false_negatives);
    end
    
    % Calcul du F1-score
    if (precision_i + recall_i) == 0
        f1_i = 0;
    else
        f1_i = 2 * (precision_i * recall_i) / (precision_i + recall_i);
    end
    
    % Moyenne pondérée du F1-score, Précision et Rappel
    precision = precision + precision_i;
    recall = recall + recall_i;
    f1_score = f1_score + f1_i;
end

% Moyenne des métriques
precision = precision / length(unique_labels);
recall = recall / length(unique_labels);
f1_score = f1_score / length(unique_labels);

% Affichage des résultats
fprintf('Precision: %.2f\n', precision);
fprintf('Recall: %.2f\n', recall);
fprintf('F1-Score: %.2f\n', f1_score);

% Visualisation des données : Petal Length vs Petal Width
figure;
scatter(trainData(:, 3), trainData(:, 4), 50, trainData(:, 5), 'filled');
title('Petal Length vs Petal Width (Training Data)');
xlabel('Petal Length');
ylabel('Petal Width');
grid on;

% Visualisation des données : Sepal Length vs Sepal Width
figure;
scatter(trainData(:, 1), trainData(:, 2), 50, trainData(:, 5), 'filled');
title('Sepal Length vs Sepal Width (Training Data)');
xlabel('Sepal Length');
ylabel('Sepal Width');
grid on;
