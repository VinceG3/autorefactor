CMS.Components.PlaylistEdit = React.createClass({
  mixins: [Reflux.ListenerMixin],

  propTypes: {
    id: React.PropTypes.string,
  },

  render: function() {
    var inputStyle = {height: '45px', width: '93%', marginRight: '10px'};
    return (
      <div className='edit-playlist'>
        <CMS.Components.PreviewButton
          clickHandler={this.handlePreview}
          id={'preview_playlist' + playlist.id}
          style={{marginLeft: '10px'}}
          text='Preview Playlist' />
      </div>
    );
  }
});
