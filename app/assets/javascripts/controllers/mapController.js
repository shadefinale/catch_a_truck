app.controller("MapCtrl", ["$scope", "$stateParams", "Restangular", function($scope, $stateParams, Restangular){
  $scope.map = {
    center: { latitude: 37.7833, longitude: -122.4167},
    zoom: 13,
    markers: [{ latitude: 37.7833, longitude: -122.4167}],
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
  }

  $scope.status = {text : "Loading..."};

  Restangular.all("food_trucks").getList().then(function(success){
    console.log(success);
    $scope.map.markers = success
    $scope.status.text = "";
  })

}])
