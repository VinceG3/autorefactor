CMS.Components.PlaylistEdit = React.createClass({
  displayName: 'PlaylistEdit',
  mixins: [Reflux.ListenerMixin],

  propTypes: {
    id: React.PropTypes.string,
    pageId: React.PropTypes.string,
    siteId: React.PropTypes.string
  },

  getInitialState: function() {
    return {
      header: {},
      headers: null,
      introCharCount: 0,
      pageTitle: null,
      pendingChange: false,
      playlist: {},
      subtextCharCount: 0,
      titleCharCount: 0
    };
  },

  componentDidMount: function() {
    this.listenTo(CMS.Stores.Headers, this.onLoadHeaders);
    this.listenTo(CMS.Actions.LoadPlaylist.completed, this.onPlaylistUpdate);
    this.listenTo(CMS.Actions.LoadPage.completed, this.onPageLoad);
    this.listenTo(CMS.Actions.SaveEditPlaylist.completed, this.onSave);
    this.listenTo(CMS.Actions.SaveNewPlaylist.completed, this.onSave);
    this.listenTo(CMS.Actions.LoadAppletvHeaders.completed, this.onAppletvHeadersUpdate);

    CMS.Actions.LoadHeaders.trigger();
    CMS.Actions.LoadAppletvHeaders.trigger();
    if (this.props.id) {
      CMS.Actions.LoadPlaylist.trigger(this.props.id);
    }

    if (this.props.pageId) {
      CMS.Actions.LoadPage.trigger(this.props.pageId);
    }

    var instance = this;
    // set event handlers

    $('#1_up_Option,#2_up_Option,#3_up_Option,#4_up_Option,#triangle_Option').off('click').on('click', function(e) {
      var playlist = instance.state.playlist;
      playlist.gridLayout = e.target.id.split('_')[0];
      instance.setState({playlist: playlist, pendingChange: true});
      var text = (e.target.id.split('_').length === 3) ? e.target.id.split('_')[0] + e.target.id.split('_')[1] : e.target.id.split('_')[0];
      $('#grid-layout-title').html(text);
      instance.validatePlaylist();
    });

    // Commented Continuous play check box until re-enable
    // Defaults play all to true for new playlist page
    // $('#inputPlayAll').prop('checked', true);

    this.validatePlaylist();
  },

  onAppletvHeadersUpdate: function(data) {
    this.setState({appletvHeaders: data.appletvHeaders});
  },

  onPageLoad: function(data) {
    if (data.error) {
      return;
    }
    this.setState({pageTitle: data.title});
  },

  registerHeaderDropdownClicks: function() {
    var headerIds = '';
    for (var i = 0; i < this.state.headers.length; i++) {
      if (i !== 0) {
        headerIds += ',';
      }
      var header = this.state.headers[i];
      headerIds += '#headertype_' + header.headerType + '_' + header.length + '_' + header.color;
    }

    var instance = this;
    $(headerIds).off('click').on('click', function(e) {
      var header = instance.state.header ? instance.state.header : {};
      header.headerType = e.target.id.split('_')[1];
      header.length = e.target.id.split('_')[2];
      header.color = e.target.id.split('_')[3];
      instance.setState({header: header, pendingChange: true});
      $('#header-type-title').html(header.headerType + ' - ' + header.length + ' - ' + header.color);
      instance.validatePlaylist();
    });
  },

  onLoadHeaders: function(data) {
    this.setState({
      headers: data.headers
    });
    this.registerHeaderDropdownClicks();
  },

  onPlaylistUpdate: function(data) {
    if (data.error) {
      CMS.Actions.Flash.Danger.trigger('There was an error. Please try again.');
      return;
    }

    var playlist = data;
    var header = (data.header) ? data.header : {};

    $('#inputTitle').val(playlist.title);
    $('#inputSlug').val(playlist.friendlyID);
    $('#inputSubtext').val(playlist.description);
    $('#inputIntro').val(playlist.introduction);
    $('#inputWatchMore').val(playlist.maxGridItems);
    $('#inputStream').prop('checked', playlist.streamEnabled);

    // Commented Continuous play check box until re-enable
    // $('#inputPlayAll').prop('checked', playlist.playAll);

    $('#inputLabelIncluded').prop('checked', header.label);
    if (header.label) {
      $('#inputLabel').val('Featured Series');
    } else {
      $('#inputLabel').val('');
    }

    $('#header-type-title').html(header.headerType + ' - ' + header.length + ' - ' + header.color);
    $('#vertical-title').html(playlist.vertical);
    $('#grid-layout-title').html(playlist.gridLayout);

    var titleCharCount = playlist.title ? playlist.title.length : 0;
    var subtextCharCount = playlist.description ? playlist.description.length : 0;
    var introCharCount = playlist.introduction ? playlist.introduction.length : 0;

    this.setState({
      header: header,
      playlist: playlist,
      titleCharCount: titleCharCount,
      subtextCharCount: subtextCharCount,
      introCharCount: introCharCount,
      vertical: playlist.vertical
    });
    this.validatePlaylist();
  },

  disableSubmit: function() {
    $('.btn-success').attr('disabled', 'disabled');
  },

  disableNeutralHeader: function() {
    return this.state.header.headerType === 'series';
  },

  onSave: function(data) {
    $('.btn-success').attr('disabled', false);
    if (data.error) {
      return;
    }

    CMS.Actions.Flash.Success.trigger('Playlist saved');

    if (this.props.id) {
      CMS.Actions.LoadPlaylist.trigger(data.id);
    } else {
      var route = Routes.edit_cms_playlist_path(data.id);
      window.location.href = route;
    }
  },

  onChangeTitle: function() {
    var title = $('#inputTitle').val() ? $('#inputTitle').val() : 'Edit Playlist';
    var titleLength = $('#inputTitle').val().length;
    this.setState({titleCharCount: titleLength});

    $('#titleHeader').html(title);
    $('#playlistBreadCrumb').html(title);
    this.validatePlaylist();
  },

  onChangeDescription: function() {
    var subtext = $('#inputSubtext').val();
    this.setState({subtextCharCount: subtext.length});
    this.validatePlaylist();
  },

  onWatchMoreChanged: function() {
    if ($('#inputWatchMore').val()) {
      if ($('#inputWatchMore').val() > 0) {
      } else {
        $('#inputWatchMore').val('');
        CMS.Actions.Flash.Danger.trigger('Watch more should be greater than 0');
      }
    }
    this.validatePlaylist();
  },

  onChangeIntro: function() {
    var intro = $('#inputIntro').val();
    this.setState({introCharCount: intro.length});

    if ($('#inputLabelIncluded').prop('checked')) {
      intro += ' Featured Series';
    }
    $('#introLabel').html(intro);
  },

  handleSavePlaylist: function() {
    this.disableSubmit();
    if (!$('#inputTitle').val()) {
      CMS.Actions.Flash.Danger.trigger('Playlist title is required. Please add a title.');
      $('.btn-success').attr('disabled', false);
      return;
    }

    var playlist = this.state.playlist;
    playlist.title = $('#inputTitle').val();

    var slug = $('.slug-field').val();
    if (slug) {
      playlist.slug = slug;
    }

    playlist.description = $('#inputSubtext').val();
    playlist.introduction = $('#inputIntro').val();
    playlist['max_grid_items'] = $('#inputWatchMore').val();
    playlist['grid_layout'] = playlist.gridLayout;
    var header = this.state.header;
    var hasLabel = $('#inputLabelIncluded').prop('checked');
    if (this.state.headers) {
      this.state.headers.forEach(function(h) {
        if (header.headerType === h.headerType && header.color === h.color && header.length === h.length && hasLabel === h.label) {
          playlist.header = h;
          playlist['header_id'] = h.id;
        }
      });
    }

    playlist.vertical = playlist.vertical;
    playlist['appletv_header'] = playlist.appletvHeader;

    playlist['stream_enabled'] = $('#inputStream').prop('checked');

    // Commented Continuous play check box until re-enable
    // playlist['play_all'] = $('#inputPlayAll').prop('checked');

    if (this.state.mobileKeyFrameImage) {
      playlist['image_filename'] = this.state.filename;
      playlist['mobile_keyframe_image'] = this.state.mobileKeyFrameImage;
    }

    if (playlist.sponsorship) {
      playlist.sponsorship['campaign_id'] = playlist.sponsorship.campaignID;
      playlist.sponsorship['image_width'] = playlist.sponsorship.imageWidth;
      playlist.sponsorship['image_height'] = playlist.sponsorship.imageHeight;
      playlist.sponsorship['mobile_image_width'] = playlist.sponsorship.mobileImageWidth;
      playlist.sponsorship['mobile_image_height'] = playlist.sponsorship.mobileImageHeight;
      playlist.sponsorship['mobile_image_width2'] = playlist.sponsorship.mobileImageWidth2;
      playlist.sponsorship['mobile_image_height2'] = playlist.sponsorship.mobileImageHeight2;
    }

    playlist['sponsorship_attributes'] = playlist.sponsorship;
    playlist['page_id'] = this.props.pageId;

    if (this.props.id) {
      CMS.Actions.SaveEditPlaylist.trigger(playlist);
    } else {
      CMS.Actions.SaveNewPlaylist.trigger(playlist);
    }
  },

  validatePlaylist: function() {

    $('#headerStatus').removeClass('status-icon-red status-icon-green');
    if (!this.state.header || !this.state.header.headerType || !this.state.header.length || !this.state.header.color) {
      $('#headerStatus').addClass('status-icon-red');
    } else {
      $('#headerStatus').addClass('status-icon-green');
    }

    $('#titleStatus').removeClass('status-icon-red status-icon-green');
    if (!$('#inputTitle').val()) {
      $('#titleStatus').addClass('status-icon-red');
    } else {
      $('#titleStatus').addClass('status-icon-green');
    }

    $('#subtextStatus').removeClass('status-icon-red status-icon-green');
    if (!$('#inputSubtext').val()) {
      $('#subtextStatus').addClass('status-icon-red');
    } else {
      $('#subtextStatus').addClass('status-icon-green');
    }

    $('#layoutStatus').removeClass('status-icon-green status-icon-red');
    if (!this.state.playlist.gridLayout) {
      $('#layoutStatus').addClass('status-icon-red');
    } else {
      $('#layoutStatus').addClass('status-icon-green');
    }

    $('#watchMoreStatus').removeClass('status-icon-green status-icon-red');
    if (!$('#inputWatchMore').val()) {
      $('#watchMoreStatus').addClass('status-icon-red');
    } else {
      $('#watchMoreStatus').addClass('status-icon-green');
    }

    $('#keyframeStatus').removeClass('status-icon-green status-icon-red');
    if ((!this.state.playlist || !this.state.playlist.mobileKeyframeImageURL) && !this.state.mobileKeyFrameImage) {
      $('#keyframeStatus').addClass('status-icon-red');
    } else {
      $('#keyframeStatus').addClass('status-icon-green');
    }
  },

  handleCancel: function() {
    if (this.canNavigateAway()) {
      window.history.back();
    }
  },

  handleItemsUpdated: function(items) {
    var playlist = this.state.playlist;
    playlist.items = items;
    this.setState({
      pendingChange: true,
      playlist: playlist
    });
  },

  handleSponsorshipChanged: function(sponsorship) {
    var playlist = this.state.playlist;
    playlist.sponsorship = sponsorship;
    sponsorship ? playlist.sponsored = true : playlist.sponsored = false;
    this.setState({
      pendingChange: true,
      playlist: playlist
    });
  },

  onCheckedChanged: function() {
    var header = this.state.header;
    header.label = $('#inputLabelIncluded').prop('checked');
    this.setState({header: header, pendingChange: true});
    if (header.label) {
      $('#inputLabel').val('Featured Series');
    } else {
      $('#inputLabel').val('');
    }
  },

  handleFile: function(e) {
    var reader = new FileReader();
    var _self = this;
    var file = e.target.files[0];
    var fieldName = e.target.name;
    this.setState({filename: file.name});
    $('input[name=' + fieldName + '_text' + ']').val(file.name);

    reader.onload = function(upload) {
      _self.setState({
        mobileKeyFrameImage: upload.target.result
      });
      _self.validatePlaylist();
    };
    reader.readAsDataURL(file);
  },

  handleItemEditSelected: function(item) {
    if (this.canNavigateAway(item)) {
      var itemId = item.playableId;
      var playableType = item.playableType;
      if (playableType === 'Story') {
        var route = Routes.edit_cms_story_path(itemId);
        window.location.href = route;
      }
    }
  },

  updateDropDownSelection: function(selection, type) {
    var playlist = this.state.playlist;
    playlist[type] = selection;

    this.setState({playlist: playlist, pendingChange: true});
    this.validatePlaylist();
  },

  paramsAreEqual: function(param1, param2) {
    if (!param1) {
      if (param2) {
        return false;
      }
      return true;
    }
    if (!param2) {
      return false;
    }
    return param1.toString() === param2.toString();
  },

  canNavigateAway: function(item) {
    if (item && item.playableType === "Today's Stories") {
      alert("You cannot edit Today's Stories");
      return false;
    }
    var pendingChange = this.state.pendingChange;

    var playlist = this.state.playlist;
    if (!this.paramsAreEqual($('#inputTitle').val(), playlist.title) ||
      !this.paramsAreEqual($('#inputSlug').val(), playlist.friendlyID) ||
      !this.paramsAreEqual(playlist.description, $('#inputSubtext').val()) ||
      !this.paramsAreEqual(playlist.introduction, $('#inputIntro').val()) ||
      !this.paramsAreEqual(playlist.maxGridItems, $('#inputWatchMore').val()) ||
      this.state.mobileKeyFrameImage) {
      pendingChange = true;
    }
    return !pendingChange || confirm('Unsaved edits will be lost if you continue');
  },

  handleDeletePlaylist: function(e) {
    e.preventDefault();
    var r = confirm('Are you sure you want to delete this playlist?');
    if (r) {
      CMS.Actions.DeletePlaylist.trigger(this.props.id);
    }
  },

  handlePreview: function(e) {
    e.preventDefault();
    var win = window.open(this.state.playlist.playlistURL, '_blank');
    win.focus();
  },

  getCharCounter: function(inputType) {
    // intro, title, subtext
    var charCount = this.state[inputType + 'CharCount'];
    var header = this.state.header;
    if (inputType === 'title' && header.length === 'long') {
      inputType = 'titleLongSeries';
    }
    var maxChars = {
      intro: 110,
      title: 40,
      titleLongSeries: 24,
      subtext: 110
    };

    var charCountColor = charCount > maxChars[inputType] ? 'type-red' : 'type-black';

    return (
      <p>
        Character Count: <span className={charCountColor}>{charCount}</span>/{maxChars[inputType]}
      </p>
    );
  },

  getPlaylistItems: function() {
    var playlist = this.state.playlist;
    if (playlist.items.length < 1) { return []; }

    var items = playlist.items;
    items.sort(function(item1, item2) {
      return item1.order < item2.order ? -1 : 1;
    });

    return items;
  },

  displayPreview: function() {
    return !!this.state.playlist.id;
  },

  getHeaderItems: function() {
    var headerItems = [];
    var headerKeys = [];
    if (this.state.headers) {
      for (var i = 0; i < this.state.headers.length; i++) {
        var header = this.state.headers[i];
        var headerKey = header.headerType + '_' + header.length + '_' + header.color;
        if (headerKeys.indexOf(headerKey) < 0) {
          headerItems.push(
            <li key={headerKey + '_' + i}><a className='capitalize' id={'headertype_' + headerKey} role='button'>
              {header.headerType + ' - ' + header.length + ' - ' + header.color}
            </a></li>);
          headerKeys.push(headerKey);
        }
      }
    }
    return headerItems;
  },

  labelStyle: {textAlign:'left', padding: '10px 0px 4px 20px', color: 'gray', fontWeight: 'normal'},

  getAppletvHeadersEdit: function() {
    if (this.state.appletvHeaders) {
      return (
        <CMS.Components.PlaylistEdit.DropDown
          label='AppleTV Header Type'
          labelStyle={this.labelStyle}
          options={this.state.appletvHeaders}
          selected={this.state.playlist.appletvHeader}
          type='appletvHeader'
          updateSelection={this.updateDropDownSelection} />
      );
    }
  },

  getDeleteBtn: function() {
    if (!this.props.id) {
      return (<button className='btn btn-danger btn-lg btn-delete-bottom' onClick={this.handleDeletePlaylist} > Delete </button>);
    }
  },

  getTitle: function() {
    return (!this.props.id && !(this.state.playlist && this.state.playlist.title)) ? 'New Playlist' : this.state.playlist.title;
  },

  getBreadcrumb: function() {
    if (this.props.siteId && this.props.pageId && this.state.pageTitle) {
      return (
        <ol className='breadcrumb pull-left mlm' style={{marginBottom: '5px'}}>
          <li><a href={Routes.edit_cms_site_page_path(this.props.siteId, this.props.pageId)}>{this.state.pageTitle}</a></li>
          <li className='active' id='playlistBreadCrumb'>{this.getTitle}</li>
        </ol>
      );
    }
  },

  getItems: function() {
    return (this.state.playlist && this.state.playlist.items) ? this.getPlaylistItems() : [];
  },

  getLabelValue: function() {
    return (this.state.header && this.state.header.label) ? 'Featured Series' : '';
  },

  dotStyle: {marginTop: '2px', marginRight: '5px'},

  getIntro: function() {
    var intro = '';
    if (this.state.playlist && this.state.playlist.introduction) {
      intro = this.state.playlist.introduction;
      if (this.state.playlist.header && this.state.playlist.header.label) {
        intro += ' Featured Series';
      }
    }
    return intro;
  },

  getMobileImagePreview: function() {
    var mobileImagePreview = <div className='col-sm-12 col-md-6' />;
    if (this.state.playlist.mobileKeyframeImageURL) {
      mobileImagePreview = (
        <div className='col-sm-6 ptm prm plm'>
          <CMS.Components.ImagePreview keyframeURL={this.state.playlist.mobileKeyframeImageURL} type='mobile' width='75%'/>
        </div>
      );
    }
    return mobileImagePreview;
  },

  render: function() {
    var inputStyle = {height: '45px', width: '93%', marginRight: '10px'};
    var requiredInputStyle = {height: '45px', display: 'inline', width: '93%', marginRight: '10px'};
    var watchMoreStyle = {height: '45px', width: '60px', display: 'inline', marginRight: '10px'};

    var playlist = this.state.playlist;

    var gridTitle = 'Select Default Layout';
    if (playlist && playlist.gridLayout) {
      gridTitle = playlist.gridLayout === 'triangle' ? playlist.gridLayout : playlist.gridLayout + 'up';
    }

    var headerTypeTitle = 'Select Header Type';
    if (this.state.header && this.state.header.headerType && this.state.header.headerType) {
      headerTypeTitle = this.state.header.headerType + ' - ' + this.state.header.length + ' - ' + this.state.header.color;
    }

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

        <div className='col-xs-12' >
          {/* header type */}
          <div className='form-group col-xs-12'>
            <label className='col-xs-12 control-label' htmlFor='headerButton' style={this.labelStyle}>
              <span className={'pull-left status-icon-green'} id='headerStatus' style={dotStyle}></span>
              Header Type
            </label>
            <div className='dropdown col-xs-12 col-md-6'>
              <button aria-expanded='true' aria-haspopup='true' className='btn btn-default dropdown-button dropdown-toggle capitalize'
                data-toggle='dropdown' id='headerButton' type='button' >
                <span id='header-type-title'>{headerTypeTitle}</span>
                <span className='caret'></span>
              </button>
              <ul aria-labelledby='dropdownMenu1' className='dropdown-menu'>
                {headerItems}
              </ul>
            </div>
          </div>
        </div>
        {/* AppleTV Headers */}
        <div className='col-xs-12'>
          {this.getAppletvHeadersEdit()}
        </div>
        {/* Info Container */}
        <div className='col-xs-12'>
          <h3 className='col-xs-12'>Info </h3>
          {/* mobile stream */}
          <div className='form-group col-xs-12'>
            <div className='col-xs-4 col-md-6' style={{marginTop: '10px'}}>
              <label>
                <input id='inputStream' name='inputStream' type='checkbox' value={false} />
                &nbsp;&nbsp;Include Playlist in Mobile Stream
              </label>
            </div>
          </div>
          {/* Commented Continuous play check box until re-enable */}
          {/* Play All */}
          {/*
            <div className='form-group col-xs-12'>
              <div className='col-xs-4 col-md-6' style={{marginTop: '10px'}}>
                <label>
                  <input id='inputPlayAll' name='inputPlayAll' type='checkbox' value={false} />
                  &nbsp;&nbsp;Enable Play All
                </label>
              </div>
            </div>
          */}
          {/* vertical */}
          <CMS.Components.PlaylistEdit.VerticalEdit
            changeVertical={this.changeVertical}
            disableNeutral={this.disableNeutralHeader()}
            header={this.state.header}
            labelStyle={this.labelStyle}
            vertical={playlist.vertical} />
          {/* label */}
          <div className='form-group col-xs-12'>
            <label className='col-xs-12 control-label' htmlFor='inputLabel' style={this.labelStyle}>Label</label>
            <div className='col-xs-8 col-md-6'>
              <input className='form-control' defaultValue={labelValue} disabled id='inputLabel' placeholder='' style={inputStyle} type='text'></input>
            </div>
            <div className='col-xs-4 col-md-6' style={{marginTop: '10px'}}>
              <label>
                <input id='inputLabelIncluded' name='inputLabelIncluded' onChange={this.onCheckedChanged} type='checkbox' value={false} />
                &nbsp;&nbsp;Label Included
              </label>
            </div>
          </div>
          {/* intro */}
          <div className='form-group col-xs-12'>
            <label className='col-xs-12 control-label' htmlFor='inputIntro' style={this.labelStyle}>Intro</label>
            <div className='col-xs-12'>
              <input className='form-control' defaultValue={playlist.introduction} id='inputIntro' onChange={this.onChangeIntro}
                placeholder='First line' style={inputStyle} type='text'></input>
              {this.getCharCounter('intro')}
            </div>
          </div>
          {/* title */}
          <div className='form-group col-xs-12' id='groupTitleId'>
            <label className='col-xs-12 control-label' htmlFor='inputTitle' style={this.labelStyle}>
              <span className={'pull-left status-icon-green'} id='titleStatus' style={dotStyle}></span>
              Title
            </label>
            <div className='col-xs-12'>
              <input className='form-control' defaultValue={playlist.title} id='inputTitle' onChange={this.onChangeTitle}
                placeholder='Main title' style={requiredInputStyle} type='text'></input>
              {this.getCharCounter('title')}
            </div>
          </div>
          {/* subtext */}
          <div className='form-group col-xs-12' id='groupSubtextId'>
            <label className='col-xs-12 control-label' htmlFor='inputSubtext' style={this.labelStyle}>
              <span className={'pull-left status-icon-green'} id='subtextStatus' style={dotStyle}></span>
              Subtext
            </label>
            <div className='col-xs-12'>
              <input className='form-control' defaultValue={playlist.description} id='inputSubtext' onChange={this.onChangeDescription}
                placeholder='Description' style={requiredInputStyle} type='text'></input>
              {this.getCharCounter('subtext')}
            </div>
          </div>
          {/* slug */}
          <div className='col-xs-12'>
            <CMS.Components.SlugEditField id={playlist.id} slug={playlist.friendlyID} type={'Playlist'} urlRoot={Common.Constants.GBS_URL + '/playlists/'}/>
          </div>
          {/* image */}
          <div className='form-group col-xs-12 pbs'>
            <label className='col-xs-12 control-label' style={this.labelStyle}>
              <span className={'pull-left'} id='keyframeStatus' style={dotStyle}></span>
              Mobile Keyframe Image
            </label>
            <div className='col-xs-12'>
              <div className='col-xs-9 npl'>
                <input className='form-control' disabled name='mobile_key_frame_image_text' style={inputStyle} type='text' />
              </div>
              <span className='btn btn-default btn-file col-xs-3 fdr fac fjc'>
                <span className='form-file-label'>Upload File</span>
                <input id='file' name='mobile_key_frame_image' onChange={this.handleFile} required={false} type='file'/>
              </span>
            </div>
            <div className='row'>
              {mobileImagePreview}
            </div>
          </div>
        </div> {/* End info Container */}
        {/* Content Container */}
        <div className='col-xs-12'>
          <h3 className='col-xs-12'>Content </h3>
          {/* default layout */}
          <div className='form-group col-xs-12'>
            <label className='col-xs-12 control-label' htmlFor='defaultLayoutButton' style={this.labelStyle}>
              <span className={'pull-left status-icon-green'} id='layoutStatus' style={dotStyle}></span>
              Choose default layout
            </label>
            <div className='dropdown col-xs-12 col-md-6'>
              <button aria-expanded='true' aria-haspopup='true' className='btn btn-default dropdown-button dropdown-toggle capitalize' data-toggle='dropdown' id='gridLayoutButton' type='button' >
                <span id='grid-layout-title'>{gridTitle}</span>
                <span className='caret'></span>
              </button>
              <ul aria-labelledby='dropdownMenu1' className='dropdown-menu'>
                <li><a id={'1_up_Option'} role='button'>1up</a></li>
                <li><a id={'2_up_Option'} role='button'>2up</a></li>
                <li><a id={'3_up_Option'} role='button'>3up</a></li>
                <li><a id={'4_up_Option'} role='button'>4up</a></li>
                <li><a id={'triangle_Option'} role='button'>Triangle</a></li>
              </ul>
            </div>
          </div>
            {/* Watch More */}
          <div className='form-group col-xs-12' id='groupWatchMoreId'>
            <div className='col-xs-12' style={{marginTop: '20px'}}>
              <div className='col-xs-8 col-sm-5 col-md-4' style={{marginTop: '10px'}}>
                <label>
                  <span className={'pull-left status-icon-green'} id='watchMoreStatus' style={dotStyle}></span>
                  Show “Watch More” after this many videos:
                </label>
              </div>
              <input className='form-control' defaultValue={playlist.maxGridItems} id='inputWatchMore' onChange={this.onWatchMoreChanged} placeholder='#' style={watchMoreStyle} type='number'></input>
            </div>
            {/* Stories */}
            <CMS.Components.PlaylistEditItems items={items}
              onItemEditSelected={this.handleItemEditSelected}
              onItemsUpdated={this.handleItemsUpdated}/>
            {/* Sponsorships */}
            <CMS.Components.SponsorshipEdit checked={playlist.sponsored} extraMobileFieldsNeeded={true} initialSponsorship={playlist.sponsorship} onSponsorshipChanged={this.handleSponsorshipChanged} />
          </div>
        </div>
        <div className='col-xs-12 col-sm-12 col-md-12 ptl' style={{display: 'inline-block'}} >
          <button className='btn btn-success btn-lg btn-save-bottom' onClick={this.handleSavePlaylist} > Save </button>
          {this.getDeleteBtn()}
          <button className='btn btn-default btn-lg btn-cancel' onClick={this.handleCancel} > Cancel </button>
        </div>
        <div className='col-xs-12' style={{marginBottom:'50px'}}></div>
      </div>
    );
  }
});
