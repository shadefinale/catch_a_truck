app.controller("MapCtrl", ["$scope", "$stateParams", "Restangular", function($scope, $stateParams, Restangular){

  var errorMsg = "No Nearby Carts Found";

  Restangular.one("food_trucks").get({'address': $stateParams.query}).then(function(success){
    $scope.map.markers = JSON.parse(success.markers);
    console.log($scope.map.markers);
    $scope.mapCenter.latitude = success.center.latitude;
    $scope.mapCenter.longitude = success.center.longitude;
    $scope.status.text = $scope.map.markers.length == 0 ? errorMsg : "";
  }, function(error){
    console.log(error);
    $scope.status.text = "Oops! There was an error. Try Again?";
  });

  $scope.status = {text : "Loading..."};

  //required hardcoding for map to load unless Restangular in resolve
  $scope.mapCenter = { id: 0, latitude: 37.7833, longitude: -122.4167};

  $scope.map = {
    center: $scope.mapCenter,
    zoom: 15,
    markers: [$scope.mapCenter],
    markersEvents: {
      click: function(marker, eventName, model, arguments) {
        console.log(marker, eventName, model, arguments);
        $scope.map.window.model = model;
        $scope.map.window.show = true;
      }
    },
    window: {
      marker: {},
      show: false,
      closeClick: function() {
          this.show = false;
      },
      options: {} // define when map is ready
    }
  };


}]);
