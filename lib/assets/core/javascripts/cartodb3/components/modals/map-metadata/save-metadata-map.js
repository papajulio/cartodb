var TITLE_SUFIX = require('../visualization-title-suffix-metadata');

module.exports = function (opts) {
  if (!opts.visDefinitionModel) throw new Error('visDefinitionModel is required');
  if (!opts.name) throw new Error('name is required');

  var visDefinitionModel = opts.visDefinitionModel;
  var successCallback = opts.onSuccess;
  var errorCallback = opts.onError;
  var name = opts.name;
  var description = opts.description;
  var tags = opts.tags;

  var oldName = visDefinitionModel.get('name');

  visDefinitionModel.save({
    name: name,
    description: description,
    tags: tags
  }, {
    wait: true,
    success: function (mdl, attrs) {
      document.title = name + TITLE_SUFIX;
      successCallback && successCallback();
    },
    error: function (mdl, e) {
      document.title = oldName + TITLE_SUFIX;
      errorCallback && errorCallback(e);
    }
  });
};
