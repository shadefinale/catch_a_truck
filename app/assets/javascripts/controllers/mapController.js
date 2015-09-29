app.controller("MapCtrl", ["$scope", "$stateParams", "Restangular", function($scope, $stateParams, Restangular){

  Restangular.one("food_trucks").get({'address': $stateParams.query}).then(function(success){
    console.log(JSON.parse(success.markers));
    $scope.map.markers = JSON.parse(success.markers);
    // debugger;
    $scope.mapCenter.latitude = Number(success.center.latitude);
    $scope.mapCenter.longitude = Number(success.center.longitude);
    $scope.status.text = "";
  }, function(error){
    console.log(error);
    $scope.status.text = "Oops! There was an error. Try Again?";
  });

  $scope.status = {text : "Loading..."};

  //required hardcoding for map to load unless Restangular in resolve
  $scope.mapCenter = { latitude: 37.7833, longitude: -122.4167};

  $scope.map = {
    center: { latitude: 37.7833, longitude: -122.4167},
    zoom: 13,
    markers: [{ id: -1, latitude: 37.7833, longitude: -122.4167}],
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
