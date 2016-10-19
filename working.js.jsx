React.createClass({
  displayName: 'PlaylistEdit',
  mixins: [Reflux.ListenerMixin],

  propTypes: {
    id: React.PropTypes.string,
    pageId: React.PropTypes.string,
    siteId: React.PropTypes.string
  },

  render: function() {
    var inputStyle = {height: '45px', width: '93%', marginRight: '10px'};
    var requiredInputStyle = {height: '45px', display: 'inline', width: '93%', marginRight: '10px'};
    var watchMoreStyle = {height: '45px', width: '60px', display: 'inline', marginRight: '10px'};
    var playlist = this.state.playlist;
    var mobileImagePreview = this.getMobileImagePreview();
    var title = this.getTitle();
    // var intro = this.getIntro();
    var items = this.getItems();
    var headerItems = this.getHeaderItems();
    var labelValue = this.getLabelValue();
    var dotStyle = this.dotStyle;

    return (
      <div className='edit-playlist'>
        <div className='col-xs-12'>
          {this.getBreadcrumb()}
          <div className='col-xs-12'>
            <h1 className='col-xs-12 col-sm-6' id='titleHeader'> {title} </h1>
            <div className='col-xs-12 col-sm-4 pull-right'>
              <button className='btn btn-success btn-lg' onClick={this.handleSavePlaylist} style={{padding: '14px 16px'}}> Save </button>
              <CMS.Components.PreviewButton
                clickHandler={this.handlePreview}
                id={'preview_playlist' + playlist.id}
                isDisplayed={this.displayPreview}
                style={{marginLeft: '10px'}}
                text='Preview Playlist' />
            </div>
          </div>
          <div className='col-xs-12'> <hr style={{margin: '20px'}}/> </div>
        </div>
      </div>
    );
  }
});
