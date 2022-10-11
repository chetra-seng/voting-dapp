// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Vote {
  struct Option{
    uint8 index;
    uint votes;
    bytes32 name;
  }

  struct VoteTopic {
    uint256 index;
    uint8 optionId;
    uint256 voterId;
    bytes32 name;
    Option[] options;
    mapping(address => uint256) voters;
  }

  mapping(uint256 => VoteTopic) private topics;
  uint256 internal topicId;

  event Voted(uint256 topicId, address voter);
  event TopicAdded(uint256 topicId, bytes32 name);
  event OptionAdded(uint256 topicId, uint8 optionId, bytes32 name);

  function addTopic(bytes32 _name) external {
    require(_name != 0, "Name can't be empty");
    topicId++;
    topics[topicId].name = _name;
    topics[topicId].index = topicId;
    emit TopicAdded(topicId, _name);
  }

  function addOption(uint256 _topicId, bytes32 _name) external {
    require(topics[_topicId].index != 0, "Topic ID not found");
    VoteTopic storage _topic = topics[_topicId];
    _topic.optionId++;

    // create new Option
    Option memory _option = Option(_topic.optionId, 0, _name);
    _topic.options.push(_option);
    emit OptionAdded(_topicId, _topic.optionId, _name);
  }

  function vote(uint256 _topicId, uint8 _optionId) external {
    require(topics[_topicId].voters[msg.sender] == 0, "Address already voted");
    VoteTopic storage topic = topics[_topicId];
    topic.voterId++;
    topic.voters[msg.sender] = topic.voterId;

    Option storage option = topic.options[_optionId];
    option.votes++;

    emit Voted(_topicId, msg.sender);
  }

  function getTopic(uint256 _topicId) external view returns (bytes32) {
    require(topics[_topicId].index != 0, "Topic ID not found");
    return topics[_topicId].name;
  }

  function getOptionCount(uint256 _topicId) external view returns (uint8) {
    require(topics[_topicId].index != 0, "Topic ID not found");
    return topics[_topicId].optionId;
  }

  function getTopicCount() external view returns (uint256) {
    return topicId;
  }

  function getOptions(uint256 _topicId, uint8 _optionId) external view returns (bytes32) {
    require(topics[_topicId].index != 0, "Topic ID not found");
    require(topics[_topicId].optionId >= _optionId, "Option ID not found");
    VoteTopic storage _topic = topics[topicId];
    for(uint i=0; i<_topic.options.length; i++){
      Option memory _option = _topic.options[i];
      if(_option.index == _optionId) {
        return (_option.name);
      }
    }
    revert("Option ID not found");
  }
}
